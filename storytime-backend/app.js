const express = require("express");
const mongoose = require("mongoose");
const app = express();
const config = require("./src/config/config");
const cors_config = require("./src/config/cors");
const db_connect = require("./src/config/db_connect")
const path = require('path');
// import routes
const usersRoute = require("./src/routes/userRoute");
// const projectRoute = require("./src/routes/projectRoute");
// const reclamationRoute = require("./src/routes/reclamationRoute");
// const taskRoute = require("./src/routes/taskRoute");
// const eventRoute = require("./src/routes/eventRoute");
// const procesRoute = require('./src/routes/procesvRoute')
// const problemRoute = require('./src/routes/problemeRoute')

//Request body parser
app.use(express.json());
app.use(express.urlencoded({ extended: true }));
//Cors config
app.use(cors_config);
// connect to DB
db_connect()
//handle static files
app.use('/static/images', express.static(path.join(__dirname, './src/static/images')))
//app.use('/projectsFile', express.static(path.join(__dirname, './src/uploads/projects')))

//define routes
app.use(`/api/v1/users`, usersRoute);

module.exports = app; 