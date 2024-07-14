const mongoose = require("mongoose");


const StorySchema = new mongoose.Schema({

    Comment: { type: String, required: true },
    Date: { type: Date, default: Date.now },
    isReported: { type: Boolean, default: false },
    User: { type: mongoose.Types.ObjectId, ref: "User" },
    Story: {type: mongoose.Types.ObjectId, ref: "Story" },
});

module.exports = mongoose.model("Comment", StorySchema);