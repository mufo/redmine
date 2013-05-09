function dateDiff(first, second) {

    // Copy date parts of the timestamps, discarding the time parts.
    var one = new Date(first.getFullYear(), first.getMonth(), first.getDate());
    var two = new Date(second.getFullYear(), second.getMonth(), second.getDate());

    // Do the math.
    var millisecondsPerDay = 1000 * 60 * 60 * 24;
    var millisBetween = two.getTime() - one.getTime();
    var days = millisBetween / millisecondsPerDay;

    // Round down.
    return Math.floor(days)
}

function getQueryStrings() {
    var q = window.location.search.substr(1), qs = {};
    if (q.length) {
        var keys = q.split("&"), k, kv, key, val, v;
        for (k = keys.length; k--; ) {
            kv = keys[k].split("=");
            key = kv[0];
            val = decodeURIComponent(kv[1]);
            if (qs[key] === undefined) {
                qs[key] = val;
            } else {
                v = qs[key];
                if (v.constructor != Array) {
                    qs[key] = [];
                    qs[key].push(v);
                }
                qs[key].push(val);
            }
        }
    }
    return qs;
}

function getNewCalandarDate(date,days_ago)
{
    var selecteddate = new Date(
        date.getFullYear(), 
        date.getMonth(), 
        date.getDate() - days_ago,
        date.getHours(),
        date.getMinutes(),
        date.getSeconds(),
        date.getMilliseconds()
    )
    return selecteddate;  
}

function add_Class_To_Selected_Date()
{
  $('.ui-datepicker-calendar tr td a.ui-state-default.ui-state-highlight').removeClass('ui-state-highlight');
  $('.ui-datepicker-calendar tr td a.ui-state-default.ui-state-active').addClass('ui-state-highlight').removeClass('ui-state-active');
}