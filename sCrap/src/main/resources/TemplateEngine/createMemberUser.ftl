    
<h2>Create a MemberUser
</h2>
    <p id="status"></p>
    <form action="" method="POST" role="form">
    

    <div class="form-group">
      <label for="memberName">Chocoholic Anonomous Member Name</label>
      <input type="text" class="form-control" id="memberName" name="memberName" placeholder="Enter name of member.">
    </div>


    <div class="form-group">
      <label for="memberNumber">Chocoholic Anonomous Member ID</label>
      <input type="text" class="form-control" id="memberNumber" name="memberNumber" placeholder="Enter ID number for member.">
    </div>


    <div class="form-group">
      <label for="memberStreetAddress">Chocoholic Anonomous Member Street Address</label>
      <input type="text" class="form-control" id="memberStreetAddress" name="memberStreetAddress" placeholder="Enter street address for member.">
    </div>


    <div class="form-group">
      <label for="memberCity">Chocoholic Anonomous Member City</label>
      <input type="text" class="form-control" id="memberCity" name="memberCity" placeholder="Enter City for member.">
    </div>


    <div class="form-group">
      <label for="memberState">Chocoholic Anonomous Member</label>
      <input type="text" class="form-control" id="memberState" name="memberState" placeholder="Enter State for member.">
    </div>


    <div class="form-group">
      <label for="memberZip">Chocoholic Anonomous Member</label>
      <input type="text" class="form-control" id="memberZip" name="memberZip" placeholder="Enter zip cod for member.">
    </div>


    <button type="submit" class="btn btn-default">Submit</button>
  </form>

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
            url: "createMemberUser
",
            data: json,
            dataType: "json",
            success : function() {
                $("#status").text("MemberUser
 SuccesFully Added");
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

<!-- End of ftl file Creator : Benjamin Haos
 -->
