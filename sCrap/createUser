    
<h2>Create a User</h2>
    <p id="status"></p>
    <form action="" method="POST" role="form">
    

    <div class="form-group">
      <label for="id">User Id (Less than 8 Characters)</label>
      <input type="text" class="form-control" id="id" name="id" placeholder="Enter a unique user id">
    </div>


    <div class="form-group">
      <label for="userName">First Name</label>
      <input type="text" class="form-control" id="userName" name="userName" placeholder="Enter a name">
    </div>


    <div class="form-group">
      <label for="num">First Name</label>
      <input type="text" class="form-control" id="num" name="num" placeholder="Enter a number">
    </div>

<!-- Simple JS Function to convert the data into JSON and Pass it as ajax Call --!>
<script>
$(function() {
    $('form').submit(function(e) {
        e.preventDefault();
        var this_ = $(this);
        var array = this_.serializeArray();
        var json = {};
    
        $.each(array, function() {
            json[this.name] = this.value || '';
        });
        json = JSON.stringify(json);
    
        // Ajax Call
        $.ajax({
            type: "POST",
            url: "createUser",
            data: json,
            dataType: "json",
            success : function() {
                $("#status").text("User SuccesFully Added");
                this_.find('input,select').val('');
            },
            error : function(e) {
                console.log(e.responseText);
                $("#status").text(e.responseText);
            }
        });
        $("html, body").animate({ scrollTop: 0 }, "slow");
        return false;
    });
});

</script>

<!-- End of ftl file Creator : Ben Haos -->
