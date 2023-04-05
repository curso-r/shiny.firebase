login = function() {
  var email = document.getElementById("email").value;
  var password = document.getElementById("password").value;
  firebase.auth().signInWithEmailAndPassword(email, password)
    .then(function(user){
      firebase.auth().currentUser.getIdToken(true).then(function(token) {
      Cookies.set("firebase_token", token);
      location.replace(window.location.protocol + '//' + window.location.hostname + ':' + window.location.port);
});
    }).catch(function(error){
     var codigoErro = error.code;
     console.log(codigoErro);
     var codigoErroExtenso = error.message;
     console.log(codigoErroExtenso);
     var mensagemPermissionDenied = 'HTTP Cloud Function returned an error: {"error":{"message":"Unauthorized user","status":"PERMISSION_DENIED"}}'

     if(codigoErro == "auth/user-not-found"){
       var mensagemErro = "Usuário não encontrado. Verifique se o email está correto. Se necessário, solicite o cadastro novamente.";
     } else if(codigoErro == "auth/wrong-password"){
       var mensagemErro = "Invalid password";
    } else if(codigoErro == "auth/internal-error" & codigoErroExtenso == mensagemPermissionDenied){
      var mensagemErro = "Unauthorized user"
    } else if(codigoErro == "auth/internal-error"){
      var mensagemErro = "Permission denied";
    } else {
        var mensagemErro = "Unspecified Firebase error";
        console.log(mensagemErro);
     }

      swal("Login error: ", mensagemErro + " \n\nPlease contact the application maintainer ", "error");
    });
}


