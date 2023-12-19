# Mongodb cluster with persistent volumes in K8s 




### Architecture Diagram 

<img src="mongodbpresistentvolume.drawio.png" >

#

- Deploy an K8s cluster in Cloud using Terraform
- Deploy an stateful mongo db cluster in GKE cluster with MERN application
- Verify cluster health and validate the cluster election in the event of master failure Validate the data


here, we are Deploy an K8s cluster in Cloud using Terraform and deployed an stateful mongo db cluster in GKE cluster with MERN application also Verify cluster health and validate the cluster election in the event of master failure Validate the data


### list of services were used 

- GKE Cluster 
- Helm 
- Mongo Db


### Prerequisites
Before using this module, you should have the following:

  - An GCP account  necessary permissions to manage resources
  - Terraform installed on your local machine
  - gcloud cli configured 
  - kubectl configured
  - helm installed on machine 
  - Docker Hub or Other Registry to store Docker image 


##### Terraform Execution: Infrastructure Resources Provisioning

Once you have finished declaring the resources, you can deploy all resources.

- terraform init: command is used to initialize a working directory containing Terraform configuration files.

- terraform plan: command creates an execution plan, which lets you preview the changes that Terraform plans to make to your infrastructure.

- terraform apply: command executes the actions proposed in a Terraform plan to create or update infrastructure.


connect cluster using command 
  
    gcloud container clusters get-credentials "$cluster_name" --region "$cluster_region"

<!--- app-name: MongoDB&reg; -->

### Install statefull MongoDB using Helm in gke 

MongoDB is a relational open source NoSQL database. Easy to use, it stores data in JSON-like documents. Automated scalability and high-performance. Ideal for developing cloud native applications.

[Overview of MongoDB&reg;](http://www.mongodb.org)


here we are using official statefull mongo db chart with some configuration changes that we required  

```console
cd MONGO-DB-CLUSTER-HELM-CHART
```
create an test_values.yaml to install mongo db with our requirments 



      architecture: replicaset
      replicaCount: 2
      auth:
        enabled: true
        rootPassword: "password"
        usernames:
          - "user"
        databases:
          - "todos"
        passwords:
          - "password"
    
.
here We are setting How many replica set we want and username and password creation 

installing Mongodb with helm chart 

    helm install mongodb -f test_values.yaml
    kubectl get pods 
 #

    NAME                                   READY   STATUS    RESTARTS         AGE        
    mongodb-0                              1/1     Running   0                1m
    mongodb-1                              1/1     Running   0                1m
    mongodb-arbiter-0                      1/1     Running   0                1m


now our mongo db cluster running succesfully in gke 
now we can check the pvc created or not for the mongodb cluster 

    kubectl get pvc 
here we can see 2 presistent volume for our mongodb pods

    NAME                STATUS   VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS   AGE
    datadir-mongodb-0   Bound    pvc-bec58d94-d698-48bf-8ff7-d842dc75a9f7   8Gi        RWO            standard-rwo   4d
    datadir-mongodb-1   Bound    pvc-b6e503d2-d1f4-45bf-83d2-47272e40e040   8Gi        RWO            standard-rwo   4d

next we need to set up backend for our application 

#### Configuring in backend Source code for connection with mongo db 


    cd ..
    cd BACKEND-SOURCE-CODE
need to add database connection string in backend source code with 

    kubectl get pods 

    NAME                                   READY   STATUS    RESTARTS         AGE        
    mongodb-0                              1/1     Running   0                1m
    mongodb-1                              1/1     Running   0                1m
    mongodb-arbiter-0                      1/1     Running   0                1m

adding database connection string in backend `server.js `

    nano server.js 
    
add db string             `mongodb://root:password@mongodb-0.mongodb-headless.default.svc.cluster.local:27017`

`mongodb://` - This is the protocol or scheme used to connect to the MongoDB server.

`root:password` - These are the credentials used to authenticate and access the MongoDB server. In this case, the username is root and the associated password is password.

`mongodb-0.mongodb-headless.default.svc.cluster.local` - This is the hostname or address of the MongoDB server. It appears to be running within a Kubernetes cluster,
 as indicated by the `.svc.cluster.local domain. mongodb-0` likely refers to a specific instance or replica set member within the MongoDB deployment.

`27017` - This is the port number on which the MongoDB server is listening for incoming connections.

    const express = require("express");
    
    const mongoose = require("mongoose");
    require("dotenv").config();
    
    const routes = require("./routes/TaskRoute");
    
    const cors = require("cors");
    
    const app = express();
    const PORT = process.env.PORT | 5000;
    
    app.use(express.json());
    app.use(cors());
    
    mongoose
      .connect("mongodb://root:password@mongodb-0.mongodb-headless.default.svc.cluster.local:27017")
      .then(() => console.log("MongoDB Connected..."))
      .catch((err) => console.log(err));
    
    app.use("/api", routes);
    
    app.listen(PORT, () => console.log(`Listening at ${PORT}`));
    

`server.js`






#### Build and Push Backend docker image to docker Hub 

    
we need to create an Docker File for Backend 

    nano Dockerfile

add the following Codes 

    FROM node:14
    WORKDIR /BACKEND-SOURCE-CODE
    COPY package.json .
    RUN npm install
    COPY . .
    CMD npm start


now build docker image with version 

    sudo docker built -t backend:v1 .
 verify
 
    sudo docker images 
#
    REPOSITORY             TAG             IMAGE ID       CREATED        SIZE
    backend                v1              c08a71a7ff59   1 min ago     951MB
    nginx                  1-alpine        414132ff3b07   5 days ago     41.4MB
    node                   16              a21a68db6806   2 weeks ago    909MB
    node                   16-slim         ab926421322d   2 weeks ago    179MB
    node                   14              1d12470fa662   4 months ago   912MB
    node                   10-alpine       aa67ba258e18   2 years ago    82.7MB
    nginx                  1.17.0-alpine   bfba26ca350c   4 years ago    20.5MB


need to push the docker image to docker hub , If you don't have one already, sign up for a Docker Hub account at https://hub.docker.com.

Login to Docker Hub:

Run the following command to log in to Docker Hub using your Docker Hub credentials:

    docker login

Tag your Image:

Before pushing the image to Docker Hub, you need to tag it with your Docker Hub username and the repository name. Use the following command:

    docker tag your-image-name:tag your-docker-hub-username/your-repo-name:tag

Replace your-docker-hub-username with your Docker Hub username and your-repo-name with the name you want for your repository on Docker Hub.

    docker push your-docker-hub-username/your-repo-name:tag

Replace your-image-name, tag, your-docker-hub-username, and your-repo-name with your actual values.

next we need set up backend service runnable 

#### deploying Backend with helm charts 

    cd ..
    cd BACKEND-HELM-CHART

we need to create a `values.yaml` files for deployement of backend with needed requirment specification 

    nano values.yaml
`values.yaml`

    replicaCount: 1
    revisionHistoryLimit: 1
    image:
      repository: abdulfayis/backend
      tag: v12
      pullPolicy: IfNotPresent
      resources:
        requests:
          cpu: 200m
          memory: 300Mi
    livenessProbe:
      initialDelaySeconds: 300
      periodSeconds: 100
    service:
      name: backend
      type: ClusterIP
      servicePort: 5000
    services:
      mongo:
         url: mongodb://mongodb-0.mongodb-headless.default.svc.cluster.local:27017
     
here we adding our mongo db url for connection 

also need to change the service of our backend ,

    cd templates 
    nano service.yaml 

add values like below 

    apiVersion: v1
    kind: Service
    metadata:
      annotations:
        prometheus.io/scrape: 'false'
      name: "backend-service"
    spec:
      ports:
      - name: http
        port: {{ .Values.service.servicePort }}
        nodePort: 30000
      type: LoadBalancer
      selector:
        app: "backend-selector"


`nodePort: 30000:` This specifies a static port on the nodes if the service type is LoadBalancer. In this case, the service can be accessed on port 30000 of the nodes.
`type: LoadBalancer:` This indicates that the service type is LoadBalancer. This means that the Kubernetes cluster (or cloud provider) will allocate an external IP and distribute traffic to the backend pods.

`selector:` This section is used to match the service to pods with specific labels.

`app: "backend-selector": `This label selector is used to associate the service with pods that have the label app set to "backend-selector".

    
now we can install backend with helm 

    cd ..
    helm install backend .

will install the backend 

    kubectl get pods 
.

    NAME                                   READY   STATUS    RESTARTS        AGE
    backend-deployment-c87d54fd5-5gwg5     1/1     Running   1(38s ago)      1mins
    mongodb-0                              1/1     Running   0               2h
    mongodb-1                              1/1     Running   0               2h
    mongodb-arbiter-0                      1/1     Running   0               2h

lets check the services

    kubectl get svc

.

    TYPE           CLUSTER-IP    EXTERNAL-IP     PORT(S)          AGE
    backend-service            LoadBalancer   10.52.4.254   34.68.199.216   5000:30000/TCP   2d21h
    kubernetes                 ClusterIP      10.52.0.1     <none>          443/TCP          5d4h
    mongodb-arbiter-headless   ClusterIP      None          <none>          27017/TCP        3d21h
    mongodb-headless           ClusterIP      None          <none>          27017/TCP        3d21h

we need to note down the external ip of backend for connection between frontend and backend 

next we need to deploy front application 

#### Configuring in frontend Source code for establish connection between backend and frontend 

need to add backend external ip in our source code to perform connection 

    cd FRONTEND-SOURCE-CODE
    
we need to change add base url of backend in our `constant.js` file for connection

    cd src/utils/
    nano constant.js
add below values to file 

    export const baseURL = "http://34.68.199.216:5000/api";

in this case of showing ip is external ip of our backend application 
thats it , now we have to build and push our docker image to registery 

#### Build and Push frontend docker image to docker Hub

    cd FRONTEND-SOURCE-CODE

we need to create an Docker File for frontend 

    nano Dockerfile
#
   
    # Stage 1
    FROM node:14 as build-stage
    
    WORKDIR /FRONTEND-SOURCE-CODE
    COPY package.json .
    RUN npm install
    COPY . .
    
    RUN npm run build
    
    
    # Stage 2
    FROM nginx:1.17.0-alpine
    
    COPY --from=build-stage /FRONTEND-SOURCE-CODE/build /usr/share/nginx/html
    EXPOSE 80
    
    ENTRYPOINT ["nginx", "-g", "daemon off;"]

`Dockerfile`
now build docker image with version 

    sudo docker built -t frontend:v1 .
 verify
 
    sudo docker images
.


    REPOSITORY             TAG             IMAGE ID       CREATED        SIZE
    frontend               v1              5dd07d1e54c2   15 mins ago     23.7MB
    backend                v1              c08a71a7ff59   1 mins ago      951MB
    nginx                  1-alpine        414132ff3b07   5 days ago     41.4MB
    node                   16              a21a68db6806   2 weeks ago    909MB
    node                   16-slim         ab926421322d   2 weeks ago    179MB
    node                   14              1d12470fa662   4 months ago   912MB
    node                   10-alpine       aa67ba258e18   2 years ago    82.7MB
    nginx                  1.17.0-alpine   bfba26ca350c   4 years ago    20.5MB

Tag your Image:

Before pushing the image to Docker Hub, you need to tag it with your Docker Hub username and the repository name. Use the following command:

    docker tag your-image-name:tag your-docker-hub-username/your-repo-name:tag

Replace your-docker-hub-username with your Docker Hub username and your-repo-name with the name you want for your repository on Docker Hub.

    docker push your-docker-hub-username/your-repo-name:tag

Replace your-image-name, tag, your-docker-hub-username, and your-repo-name with your actual values.

next we need set up frontend service runnable 

#### deploying frontend with helm charts 

    cd ..
    cd FRONDEND-HELM-CHART

we need to create a `values.yaml` files for deployement of backend with needed requirment specification 

    nano values.yaml
`values.yaml`

    replicaCount: 1
    revisionHistoryLimit: 1
    image:
      repository: abdulfayis/frontend
      tag: v13
      pullPolicy: IfNotPresent
      resources:
        requests:
          cpu: 200m
          memory: 300Mi
    livenessProbe:
      initialDelaySeconds: 30
      periodSeconds: 10
    service:
      name: frontend
      type: NodePort
      servicePort: 80 # the port where nginx serves its traffic

`replicaCount:` This specifies the number of replica pods that should be created for this deployment. In this case, there's only one replica.


`image:` This section defines the Docker image to use for the deployment.

`repository:` Specifies the Docker image repository. Here, it's set to `abdulfayis/frontend`

`tag:` Specifies the image tag to use. In this case, the version v13 of the image is used.


`service:` This section defines the service associated with the deployment.

`name:` Specifies the name of the service as frontend.

`type`: Specifies the service type. Here, it's NodePort, meaning the service will be exposed on a port on each node.

`servicePort: `Specifies the port on which the service will be available. In this case, the service will be available on port 80.
.
.
.

also need to change the service of our frontend  ,

    cd templates 
    nano service.yaml 

`service.yaml`

    apiVersion: v1
    kind: Service
    metadata:
      annotations:
        prometheus.io/scrape: 'false'
      name: "frontend-service"
    spec:
      ports:
      - name: http
        port: {{ .Values.service.servicePort }}
        nodePort: 30443
      type: LoadBalancer
      selector:
        app: "frontend-selector"


`nodePort:` 30443: This specifies a static port on the nodes if the service type is LoadBalancer. In this case, the service can be accessed on port 30443 of the nodes.
`type: LoadBalancer:` This indicates that the service type is LoadBalancer. This means that the Kubernetes cluster (or cloud provider) will allocate an external IP and distribute traffic to the frontend pods.

`selector:` This section is used to match the service to pods with specific labels.

`app: "frontend-selector": `This label selector is used to associate the service with pods that have the label app set to "frontend-selector".


now we can install backend with helm 

    cd ..
    helm install frontend .

will install the backend 

    kubectl get pods 
.

    NAME                                   READY   STATUS    RESTARTS        AGE
    backend-deployment-c87d54fd5-5gwg5     1/1     Running   1(38s ago)      1mins
    frontend-deployment-7f5564d9d6-6cc9g   1/1     Running   0               15h
    mongodb-0                              1/1     Running   0               2h
    mongodb-1                              1/1     Running   0               2h
    mongodb-arbiter-0                      1/1     Running   0               2h

lets check services that deployed

    NAME                       TYPE           CLUSTER-IP    EXTERNAL-IP     PORT(S)          AGE
    backend-service            LoadBalancer   10.52.4.254   34.68.199.216   5000:30000/TCP   2d23h
    frontend-service           LoadBalancer   10.52.15.65   35.224.39.224   80:30443/TCP     15h
    kubernetes                 ClusterIP      10.52.0.1     <none>          443/TCP          5d6h
    mongodb-arbiter-headless   ClusterIP      None          <none>          27017/TCP        3d22h
    mongodb-headless           ClusterIP      None          <none>          27017/TCP        3d22h

browse the external ip of frontend service 

    http://<external-ip>

will get our application 

<img src="application.png">


next we need to check the file were stored in db or not 
here iam using a studio 3t tool to examine db by redirectiing our db into local host 

need to redirect our db master into local host port of 27107

    kubectl port-forward pod/mongodb-0 27017:27017

then we need to use  studio 3t tool 

connect through `mongodb://root:123456@localhost:27017/` this db string 

    mongodb://user:password@localhost:27017/

check the data were stored or not 

<img src="studio3t-data-validation1.png">

its successfully stored in Mongodb Master pod

lets check in slave pod db 
so we need to portforward the slave pod 


    kubectl port-forward pod/mongodb-1 27017:27017

then we need to use  studio 3t tool 

connect through `mongodb://root:123456@localhost:27017/` this db string 

    mongodb://user:password@localhost:27017/

check the data were stored or not 

we can see also the same data were stored in slave db by using studio 3t

now we can validate the cluster election in the event of master failure

### validate the cluster election in the event of master failure

here we can test with deletion of our master pod db 

    kubectl get pods 
    -------------------
    backend-deployment-c87d54fd5-5gwg5     1/1     Running   432 (8m13s ago)   3d
    frontend-deployment-7f5564d9d6-6cc9g   1/1     Running   0                 16h
    mongodb-0                              1/1     Running   0                 2d23h
    mongodb-1                              1/1     Running   0                 3d23h
    mongodb-arbiter-0                      1/1     Running   0                 3d23h

delete the master db pod 

    kubectl delete pod mongodb-0
will delete the master 

after deletion in seconds we can see the master pod will creates and runs successfully , in this case we can get a little down time in our application . (lessthan 10 seconds )


<img src="masterdeletion.png">

thats it, 

### Refrence 

https://aliartiza75.medium.com/mongodb-deployment-on-k8s-cluster-using-vanilla-manifest-helm-charts-eaf542371c1b

https://studio3t.com/

https://www.freecodecamp.org/news/what-is-a-helm-chart-tutorial-for-kubernetes-beginners/

https://www.digitalocean.com/community/tutorials/how-to-scale-a-node-js-application-with-mongodb-on-kubernetes-using-helm    


