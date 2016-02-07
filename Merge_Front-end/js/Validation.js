function validate()
{
	var uname= document.getElementById("username");
	var emale= document.getElementById("email");
	var c_emale= document.getElementById("c_email");
	var passw= document.getElementById("password");


	if (uname.value==""){
	alert("Username field required");}

    if (emale.value=="")
	{alert("Email field required");
	var filter = /^([a-zA-Z0-9_\.\-])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+$/;}
	
	if (!filter.test(emale.value)) {
   alert('Please provide a valid email address');}

    if (c_emale.value!=emale.value)
	{alert("Email does not match");}

    if (passw.value.length<8)
	{alert("Password Must Be At least 8 Characters");}

 }