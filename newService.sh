#!/bin/bash

echo "--------------------------------------------------------------------"
echo "--------------------------------------------------------------------"
echo "--------------------------------------------------------------------"
echo "---------------------------------Automata---------------------------"
echo "---------------------starting microsrvice conf ---------------------"
echo "--------------------------------------------------------------------"
echo "--------------------------------------------------------------------"
echo "--------------------------------------------------------------------
"
#check if the required params are supplied
if [ -z "$1" ]
  then
    echo "Project microservice name is required to proceed"
    sleep 5s
    exit 0
fi

# define script variables
PROJECT_NAME=$1
mkdir "$1" && cd ./"$1"

echo "---------------creating dotnet api----------------

"
dotnet new webapi
echo "---------------------dotnet api created -----------------"
sleep 2s
echo "

--------------------------------------------------------------------"
echo "--------------------------------------------------------------------

"
echo "---------------installing default sbsa packages----------------
"
#install packages
#SwashBuckle
dotnet add package Swashbuckle.AspNetCore
#Newtonsoft.Json
dotnet add package Newtonsoft.Json

#if MongoDB 
if ["$2"="nosql"]
    then
        
       dotnet add package MongoDB.Driver
fi

#appmetrics
dotnet add package App.Metrics
dotnet add package NLog

echo "---------------done installing required packages----------------"

echo "

--------------------------------------------------------------------"
echo "--------------------------------------------------------------------

"
sleep 5s

echo "---------------creating container dependecies----------------
"
touch "Dockerfile" 

echo "#minimal secure alpine image (microsoft official)
#cbuilt image - blackbeard tech
FROM leontinashe/bhalpinedotnet:2.2-dotnetcore-runtime AS base
WORKDIR /app
ENV ASPNETCORE_URLS http://*:5000
EXPOSE 5000

#microsoft official .net sdk build 
FROM mcr.microsoft.com/dotnet/core/sdk:2.2-stretch AS build
WORKDIR /src
#copy project file to build
RUN mkdir cid
WORKDIR "/src/$1"
COPY "$1.csproj" .
RUN dotnet restore "$1.csproj"
COPY . .
WORKDIR "/src/$1"
RUN dotnet build "$1.csproj" -c Release -o /app

#publish build from sdk build 
FROM build AS publish
RUN dotnet publish "$1.csproj" -c Release -o /app

#run build published output
FROM base AS final
#harden alpine config, update and patch
RUN apk add --update duo_unix
COPY hardensecurity.sh /usr/sbin/hardensecurity.sh
RUN chmod +x /usr/sbin/hardensecurity.sh
#USER user
#RUN /usr/sbin/harden.sh
WORKDIR /app
#port app and run
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "$1.dll"]
" >> "Dockerfile"
echo "---------------container dependecies done----------------"

echo "

--------------------------------------------------------------------"
echo "--------------------------------------------------------------------

"


echo "$1 project created"
sleep 5