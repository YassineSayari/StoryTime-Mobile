const http = require("http")
const app = require("./app");
const config = require("./src/config/config")
const user_model = require("./src/models/user");
const bcrypt = require("bcryptjs");

const PORT = config.PORT;
const NODE_ENV = config.NODE_ENV;

const server = http.createServer(app);
server.listen(PORT, () => console.log("Server listening on port ", PORT));

//for test
//create admin account

async  function initAdminAccount(){
    console.log("========== INIT ADMIN ACCOUNT =========");
   const users = await user_model.find({});
   if(users.length == 0){
    hashedPassword = await bcrypt.hash("admin", 10);
        await user_model.create({
            fullName : "admin",
            email : "admin@mail.com",
            password : hashedPassword,
            phone: "1111111",
            roles: "Admin",
            gender : "male",
            image : "",
            isEnabled : true
        })
   }
}

initAdminAccount();


console.log(`============ APP RUNNING IN ${NODE_ENV.toUpperCase()} MODE ============`);