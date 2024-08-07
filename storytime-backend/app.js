const express = require("express");
const mongoose = require("mongoose");
const app = express();
const config = require("./src/config/config");
const cors_config = require("./src/config/cors");
const db_connect = require("./src/config/db_connect")
const path = require('path');

const passport = require('passport');
require('./src/config/passport-setup');


// import routes
const usersRoute = require("./src/routes/userRoute");
const storyRoute = require("./src/routes/storyRoute");
const commentRoute = require("./src/routes/commentRoute");
//Request body parser
app.use(express.json());
app.use(express.urlencoded({ extended: true }));
//Cors config
app.use(cors_config);
// connect to DB
db_connect()
//handle static files
app.use('/static/images', express.static(path.join(__dirname, './src/static/images')))

//define routes
app.use(`/api/v1/users`, usersRoute);
app.use(`/api/v1/stories`, storyRoute);
app.use(`/api/v1/comments`, commentRoute);

module.exports = app; 