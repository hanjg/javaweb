/*
 * $RCSfile$
 * $Revision: 27700 $
 * $Date: 2006-02-23 13:34:13 -0600 (Thu, 23 Feb 2006) $
 *
 * Copyright (C) 2003 Jive Software. All rights reserved.
 *
 * This software is the proprietary information of Jive Software. Use is subject to license terms.
 */

// Override the default trim method of String.
String.prototype.trim = function () {
    var text = this;
    var start = 0;
    var end = text.length;
    var display = "";
    for (var i=0; i<text.length; i++) {
        display += text.charCodeAt(i) + " ";
    }
    for (var i=0; i<text.length; i++) {
        var code = text.charCodeAt(i);
        if (code >= 33) {
            start = i;
            break;
        }
        else {
            start++;
        }
    }
    for (var i=text.length; i>start; i--) {
        var code = text.charCodeAt(i-1);
        if (code >= 33) {
            end = i;
            break;
        }
    }
    return text.substring(start,end);
}

// variable to tell whether or not a form has been clicked
var clicked = false;

function allowClick() {
    if (!clicked) {
        clicked = true;
        return true;
    }
    return false;
}

// Sequence for open window names
var windowNameSeq = 0;

// Array of all open windows
var windows = new Array();

// Checks to see if a window exists
function windowExists(name) {
    for (var i=0; i<windows.length; i++) {
        // IE needs a try/catch here for to avoid an access violation on windows[i].name
        // in some cases.
        try {
            if (windows[i].name == name) {
                return true;
            }
        }
        catch (exception) {}
    }
    return false;
}

// Returns the window object - returns nothing if not found.
function getWindow(name) {
    for (var i=0; i<windows.length; i++) {
        try {
            if (windows[i].name == name) {
                return windows[i];
            }
        }
        catch (exception) {}
    }
}

function removeWindow(name) {
    for (var i=0; i<windows.length; i++) {
        try {
            if (windows[i].name == name) {
                windows.splice(i, 1);
                return;
            }
        }
        catch (exception) {}
    }
}

// Open a window given its unique name, url, width and height.
function pushWin(name, url, width, height) {
    var defaultOptions = "location=yes,status=yes,toolbar=no,personalbar=no,menubar=no,directories=no,";
    defaultOptions += "scrollbars=yes,resizable=yes,";
    defaultOptions += "width=" + width + ",height=" + height;
    launchWinWithOptions(name, url, defaultOptions);
}

// Open a window given its unique name, url, width and height.
function launchWin(name, url, width, height) {
    name = name.replace(" ", "_");
    var defaultOptions = "location=no,status=no,toolbar=no,personalbar=no,menubar=no,directories=no,";
    var winleft = (screen.width - width) / 2;
    var winUp = (screen.height - height) / 2;
  
    defaultOptions += "scrollbars=no,resizable=yes,top="+winUp+",left="+winleft+",";
    defaultOptions += "width=" + width + ",height=" + height;
    launchWinWithOptions(name, url, defaultOptions);
}

// Open a window with given name, url, and options list
function launchWinWithOptions(name, url,  options) {
    if (!windowExists(name)) {
        var winVar = window.open(url, name, options);
        windows[windows.length] = winVar;
        return winVar;
    }
    else {
        var theWin = getWindow(name);
        theWin.focus();
    }
}

function getTopLevelWindow() {
    var win = window;
    if (win.parent == win) {
        return win;
    }
    while (win.parent != win) {
        win = window.parent.window;
    }
    return win;
}

// Close the current window object
function closeWin(win) {
    win.close();
}

// Handle closing of the current window
function handleClose(message) {
    if (confirm(message)) {
        removeWindow(getTopLevelWindow().name);
        closeWin(getTopLevelWindow());
        return true;
    }
    else {
        return false;
    }
}

// Handle closing of the current window
function confirmCancel(message) {
    if (confirm(message)) {
        getTopLevelWindow().location.href = 'userinfo.jsp';
        return true;
    }
    else {
        return false;
    }
}

function confirmCancelAndClose(message) {
    if (confirm(message)) {
     getTopLevelWindow().location.href = 'userinfo.jsp';
        getTopLevelWindow().close();
        return true;
    }
    else {
        return false;
    }
}

// Handle closing of the current window
function confirmCancel(message,workgroup) {
    if (confirm(message)) {
        getTopLevelWindow().location.href = 'userinfo.jsp?workgroup='+workgroup;
        return true;
    }
    else {
        return false;
    }
}

function closeAll() {
  removeWindow(getTopLevelWindow().name);
  closeWin(getTopLevelWindow());      
}

// Opens the help window:
function launchHelpWin() {
    var win = launchWin('helpwin', 'helpwin.jsp', 550,350);
}

// Hide a DIV
function hide(divId) {
    if (document.layers) { document.layers[divId].visibility = 'hide'; }
    else if (document.all) { document.all[divId].style.visibility = 'hidden'; }
    else if (document.getElementById) { document.getElementById(divId).style.visibility = 'hidden'; }
}

// Show a DIV
function show(divId) {
    if (document.layers) { document.layers[divId].visibility = 'show'; }
    else if (document.all) { document.all[divId].style.visibility = 'visible'; }
    else if (document.getElementById) { document.getElementById(divId).style.visibility = 'visible'; }
}

function getDiv(divID) {
    if (document.layers) { return document.layers[divID]; }
    else if (document.all) { return document.all[divID]; }
    else if (document.getElementById) { return document.getElementById(divID); }
}

function getDivByDoc(divID, doc) {
    if (doc.layers) { return doc.layers[divID]; }
    else if (doc.all) { return doc.all[divID]; }
    else if (doc.getElementById) { return doc.getElementById(divID); }
}

// TODO
function showTypingIndicator(flag) {
    if (flag) {
        // put the text in the div
    }
    else {
        // blank out the div
    }
}

function informConnectionClosed() {
    alert('Your support session has ended, you will be redirected to the transcript page.');
    parent.location.href = 'transcriptmain.jsp';
}


function addPerson(roomWin, person, isModerator, isAdmin, blocked, voice){
    var p = escape(person);
    if(nicknameExists(roomWin, person)){
      return;
    }

  // The div to write to:
    var peopleDiv = roomWin.document.getElementById('rtext');
    var numChildren = peopleDiv.childNodes.length;
    var lineDiv = roomWin.document.createElement("div");
    lineDiv.setAttribute("class", "room-info");
    lineDiv.setAttribute("nickname", person);
    lineDiv.setAttribute("moderator", isModerator);
    lineDiv.setAttribute("blocked", blocked);
    lineDiv.setAttribute("voice", voice);
    lineDiv.setAttribute("admin", isAdmin);

    var userNickname = roomWin.parent.getNickname();
    var isUser = (userNickname == person);


    if(isModerator == 'true'){
      lineDiv.setAttribute("alt",  "Moderator");
    }
    else {
      lineDiv.setAttribute("alt", "Participant");
    }


    var image = 'images//user.gif';
    if(isModerator){
      image = 'images/moderator.gif';
    }
    else if(!voice){
      image = 'images/no_voice.gif';
    }
    else if(blocked){
      image = 'images/banned_user.gif';
    }
    if(isAdmin){
      image = 'images/admin.gif';
    }

    if(!isUser){
      lineDiv.innerHTML = "<table style=\"cursor:pointer;cursor: hand\" border=0 onclick=\"parent.changeTheRow('"+p+"');\"><tr><td><img border=0 src='"+image+"' valign=middle></td><td class=room-info>"+person+"</td></tr></table>";
    }
    else {
      lineDiv.innerHTML = "<table style=\"cursor:pointer;cursor: hand\" border=0 onclick=\"parent.changeTheRow('"+p+"');\"><tr><td><img border=0 src='"+image+"' valign=middle></td><td class=room-info><b>"+person+"</b></td></tr></table>";
    }

    peopleDiv.appendChild(lineDiv);
}


function changePersonImage(roomWin, person, image){
  var imagenode = getPersonElement(roomWin, person);
  if(imagenode != null){
    var p = escape(person);
    var userNickname = roomWin.parent.getNickname();
    var isUser = (userNickname == person);
    if(!isUser) {
      imagenode.innerHTML = "<table style=\"cursor:pointer;cursor: hand\" border=0 onclick=\"parent.changeTheRow('"+p+"');\"><tr><td><img border=0 src='"+image+"' valign=middle></td><td class=room-info>"+person+"</td></tr></table>";
    }
    else {
      imagenode.innerHTML = "<table style=\"cursor:pointer;cursor: hand\" border=0 onclick=\"parent.changeTheRow('"+p+"');\"><tr><td><img border=0 src='"+image+"' valign=middle></td><td class=room-info><b>"+person+"</b></td></tr></table>";
    }

  }
}

function removeAllPeople(roomWin){
     var peopleDiv = roomWin.document.getElementById('rtext');
     var col = peopleDiv.getElementsByTagName("div");
     while(true){
       var el = col[0];
       if(el != null){
         peopleDiv.removeChild(el);
       }
       else {
         break;
       }
     }
}



function nicknameExists(roomWin, person){
    var rDiv = roomWin.document.getElementById('rtext');
    var numChildren = rDiv.childNodes.length;
    for(i=0;i<numChildren;i++){
      var chatLineDiv = rDiv.childNodes[i];
      if(chatLineDiv.getAttribute("nickname") == person){
        return true;
      }
    }
    return false;
}

function getPersonElement(roomWin, person){
    var rDiv = roomWin.document.getElementById('rtext');
    var numChildren = rDiv.childNodes.length;
    for(i=0;i<numChildren;i++){
      var chatLineDiv = rDiv.childNodes[i];
      if(chatLineDiv.getAttribute("nickname") == person){
        return chatLineDiv;
      }
    }
    return null;
}

function removePerson(roomWin, person){
// The div to write to:
    var rDiv = roomWin.document.getElementById('rtext');
    var numChildren = rDiv.childNodes.length;
    for(i=0;i<numChildren;i++){
      var chatLineDiv = rDiv.childNodes[i];
      if(chatLineDiv != null && chatLineDiv.getAttribute("nickname") == person){
        rDiv.removeChild(chatLineDiv);
      }
    }
}

function getPreviousPerson(roomWin, person){
  // The div to write to:
      var rDiv = roomWin.document.getElementById('rtext');
      var numChildren = rDiv.childNodes.length;
      for(i=0;i<numChildren;i++){
        var chatLineDiv = rDiv.childNodes[i];
        if(chatLineDiv != null && chatLineDiv.getAttribute("nickname") == person){
           if(i>0){
             return rDiv.childNodes[i-1];
           }
           else {
             return null;
           }
        }
      }
}

function getPersonAfter(roomWin, person){
  // The div to write to:
      var rDiv = roomWin.document.getElementById('rtext');
      var numChildren = rDiv.childNodes.length;
      for(i=0;i<numChildren;i++){
        var chatLineDiv = rDiv.childNodes[i];
        if(chatLineDiv != null && chatLineDiv.getAttribute("nickname") == person){
           if(i>0){
             return rDiv.childNodes[i + 1];
           }
           else {
             return null;
           }
        }
      }
}

function getFirstPerson(roomWin){
  // The div to write to:
      var rDiv = roomWin.document.getElementById('rtext');
      var numChildren = rDiv.childNodes.length;
      if(numChildren > 0){
        return rDiv.childNodes[0];
      }
      return null;
}

function hasPeople(roomWin){
  // The div to write to:
      var rDiv = roomWin.document.getElementById('rtext');
      var numChildren = rDiv.childNodes.length;
      if(numChildren > 0){
        return true;
      }
      return false;
}


function insertText(yakWin, text){
    // The div to write to:
    var yakDiv = yakWin.document.getElementById('ytext');

    // Create a new span node in the yakDiv. Record the num of nodes right now - used later
    // to see if the node was really added:
    var chatLineDiv = yakWin.document.createElement("div");
    chatLineDiv.setAttribute("class", "private-message");

    try {
        chatLineDiv.innerHTML = "<span class='private-message'>"+text+"</span>";
        yakDiv.appendChild(chatLineDiv);
    }
    catch (exception) {
    }
}

function insertHistoryText(yakWin, text){
    // The div to write to:
    var yakDiv = yakWin.document.getElementById('ytext');

    // Create a new span node in the yakDiv. Record the num of nodes right now - used later
    // to see if the node was really added:
    var chatLineDiv = yakWin.document.createElement("div");
    chatLineDiv.setAttribute("class", "history-message");

    try {
        chatLineDiv.innerHTML = "<span class='history-message'>"+text+"</span>";
        yakDiv.appendChild(chatLineDiv);
    }
    catch (exception) {
    }
}

function insertErrorText(yakWin, text){
    // The div to write to:
    var yakDiv = yakWin.document.getElementById('ytext');

    // Create a new span node in the yakDiv. Record the num of nodes right now - used later
    // to see if the node was really added:
    var chatLineDiv = yakWin.document.createElement("div");
    chatLineDiv.setAttribute("class", "error-message");

    try {
        chatLineDiv.innerHTML = "<span class='error-message'>"+text+"</span>";
        yakDiv.appendChild(chatLineDiv);
    }
    catch (exception) {
    }
}

function clearChat(yakWin){
   // The div to write to:
    var yakDiv = yakWin.document.getElementById('ytext');
    var numChildren = yakDiv.childNodes.length;
    for(i=0;i<numChildren;i++){
      var chatLineDiv = yakDiv.childNodes[i];
      yakDiv.removeChild(chatLineDiv);
      numChildren = yakDiv.childNodes.length;
      if(numChildren == 0){
        return;
      }
    }
}

function addChatText(yakWin, from, text) {
    // The div to write to:
    var yakDiv = yakWin.document.getElementById('ytext');

    // This will be an announcement if there is no from passed in
    var isAnnouncement = (from == "");

    // Create a new span node in the yakDiv. Record the num of nodes right now - used later
    // to see if the node was really added:
    var numChildren = yakDiv.childNodes.length;
    var nameSpan = document.createElement("span");
    var textSpan = document.createElement("span");

    if (isAnnouncement) {
        nameSpan.setAttribute("class", "chat-announcement");
        textSpan.setAttribute("class", "chat-announcement");
    }
    else {
        textSpan.setAttribute("class", "text");
    }

    // add another span containing the username if this is not an announcement:
    var fromIsCurrentUser = false;
    if (!isAnnouncement) {
        // is the from the same as the current user?
        fromIsCurrentUser = (nickname == from);

        if (fromIsCurrentUser) {
            nameSpan.setAttribute("class", "client-name");
        }
        else {
            nameSpan.setAttribute("class", "operator-name");
        }
    }

    var chatLineDiv = document.createElement("div");
    chatLineDiv.setAttribute("class", "chat-line");

    var appendFailed = false;
    try {

        if (!isAnnouncement) {
            nameSpan.innerHTML = from + ": ";
            chatLineDiv.appendChild(nameSpan);
        }

        textSpan.innerHTML = text;
        chatLineDiv.appendChild(textSpan);

        yakDiv.appendChild(chatLineDiv);
    }
    catch (exception) {
        appendFailed = true;
    }

    if (!appendFailed) {
        // Make sure the browser appended:
        appendFailed = (numChildren == yakDiv.childNodes.length);
    }

    if (appendFailed) {
        var inn = yakDiv.innerHTML;
        inn += "<div class=\"chat-line\">";

        if (!isAnnouncement) {
            inn += "<span class=\"";
            if (isAnnouncement) {
                inn += "chat-announcement";
            }
            else if (fromIsCurrentUser) {
                inn += "client-name";
            }
            else {
                inn += "operator-name";
            }

            inn += "\">" + from + ": </span>";
            // yakDiv.innerHTML = inn;
        }

        // var inn = yakDiv.innerHTML;

        inn += "<span class=\"";
        inn += (isAnnouncement ? "chat-announcement\">" : "chat_text\">");
        inn += text + "</span></div>";

        yakDiv.innerHTML = inn;
    }
    else {
        // yakDiv.appendChild(document.createElement("br"));
    }
}


function addChatTextAndDate(yakWin, date, from, text) {
    // The div to write to:
    var yakDiv = yakWin.document.getElementById('ytext');

    // This will be an announcement if there is no from passed in
    var isAnnouncement = (from == "");

    // Create a new span node in the yakDiv. Record the num of nodes right now - used later
    // to see if the node was really added:
    var numChildren = yakDiv.childNodes.length;
    var nameSpan = document.createElement("span");
    var textSpan = document.createElement("span");

    if (isAnnouncement) {
        nameSpan.setAttribute("class", "chat-announcement");
        textSpan.setAttribute("class", "chat-announcement");
    }
    else {
        textSpan.setAttribute("class", "text");
    }

    // add another span containing the username if this is not an announcement:
    var fromIsCurrentUser = false;
    if (!isAnnouncement) {
        // is the from the same as the current user?
        fromIsCurrentUser = (nickname == from);

        if (fromIsCurrentUser) {
            nameSpan.setAttribute("class", "client-name");
        }
        else {
            nameSpan.setAttribute("class", "operator-name");
        }
    }

    if(!isAnnouncement && !fromIsCurrentUser){
        var encodedFrom = escape(from);
          from = "<a class=\"operator-name\" href=javascript:parent.openIM('"+encodedFrom+"')> "+from+"</a>";
    }



    var chatLineDiv = document.createElement("div");
    chatLineDiv.setAttribute("class", "chat-line");

    var appendFailed = false;
    try {

        if (!isAnnouncement) {
            nameSpan.innerHTML = date+" "+from + ": ";
            chatLineDiv.appendChild(nameSpan);
        }

        textSpan.innerHTML = text;
        chatLineDiv.appendChild(textSpan);

        yakDiv.appendChild(chatLineDiv);
    }
    catch (exception) {
        appendFailed = true;
    }

    if (!appendFailed) {
        // Make sure the browser appended:
        appendFailed = (numChildren == yakDiv.childNodes.length);
    }

    if (appendFailed) {
        var inn = yakDiv.innerHTML;
        inn += "<div class=\"chat-line\">";

        if (!isAnnouncement) {
            inn += "<span class=\"";
            if (isAnnouncement) {
                inn += "chat-announcement";
            }
            else if (fromIsCurrentUser) {
                inn += "client-name";
            }
            else {
                inn += "operator-name";
            }

            inn += "\">" + date+ " "+from + ": </span>";
            // yakDiv.innerHTML = inn;
        }

        // var inn = yakDiv.innerHTML;

        inn += "<span class=\"";
        inn += (isAnnouncement ? "chat-announcement\">" : "chat_text\">");
        inn += text + "</span></div>";

        yakDiv.innerHTML = inn;
    }
    else {
        // yakDiv.appendChild(document.createElement("br"));
    }
}


function addHistoryText(yakWin, date, from, text) {
    // The div to write to:
    var yakDiv = yakWin.document.getElementById('ytext');

    // This will be an announcement if there is no from passed in
    var isAnnouncement = (from == "" || from == null);

    // Create a new span node in the yakDiv. Record the num of nodes right now - used later
    // to see if the node was really added:
    var numChildren = yakDiv.childNodes.length;
    var nameSpan = document.createElement("span");
    var textSpan = document.createElement("span");
    nameSpan.setAttribute("class", "history-message");
    textSpan.setAttribute("class", "chat-line");



    // add another span containing the username if this is not an announcement:
    var fromIsCurrentUser = false;
    if (!isAnnouncement) {
        // is the from the same as the current user?
        fromIsCurrentUser = (nickname == from);
    }
    else {
        textSpan.setAttribute("class", "history-message");
    }

    var chatLineDiv = document.createElement("div");

    var appendFailed = false;
    try {

        if (!isAnnouncement) {
            nameSpan.innerHTML = date+" "+from + ": ";
            chatLineDiv.appendChild(nameSpan);
        }

        textSpan.innerHTML = text;
        chatLineDiv.appendChild(textSpan);

        yakDiv.appendChild(chatLineDiv);
    }
    catch (exception) {
        appendFailed = true;
    }

    if (!appendFailed) {
        // Make sure the browser appended:
        appendFailed = (numChildren == yakDiv.childNodes.length);
    }

    if (appendFailed) {
        var inn = yakDiv.innerHTML;
        inn += "<div class=\"history-message\">";

        if (!isAnnouncement) {
            inn += "<span class=\"";
            if (isAnnouncement) {
                inn += "history-message";
            }
            else if (fromIsCurrentUser) {
                inn += "history-message";
            }
            else {
                inn += "history-message";
            }

            inn += "\">" + date+" "+from + ": </span>";
            // yakDiv.innerHTML = inn;
        }

        // var inn = yakDiv.innerHTML;

        inn += "<span class=\"";
        inn += (isAnnouncement ? "history-message\">" : "history-message\">");
        inn += text + "</span></div>";

        yakDiv.innerHTML = inn;
    }

}



function addPrivateMessage(yakWin, from, text) {
    // The div to write to:
    var yakDiv = yakWin.document.getElementById('ytext');
    var lineDiv = yakWin.document.createElement("div");
    var isCurrentUser = (nickname == from);
    // This will be an announcement if there is no from passed in
    var newMessage = "<table width=100%>";

    var participant = escape(from);
    var link = "<a href=javascript:parent.openIM('"+participant+"')><b><u>"+text+"</b></u></a><br/>";

  

    newMessage += "<tr><td class=private-message colspan=2>Private Message from " + from + " (Click to join)</td></tr>";
    newMessage += "<tr height=1><td colspan=2 bgcolor=#d3d5d6 height=1></td></tr>";
    newMessage += "<tr><td colspan=2 class=chat-line>" + link + "</td></tr>";

    newMessage += "</table>";

    lineDiv.innerHTML = newMessage;
    yakDiv.appendChild(lineDiv);
}

function scrollYakToEnd (yakWin) {
    var endDiv = yakWin.document.getElementById('enddiv');
    yakWin.scrollTo(0, yakWin.document.body.scrollHeight);
}

function scroll(yakWin){
 yakWin.scrollBy(0, 40);
}




