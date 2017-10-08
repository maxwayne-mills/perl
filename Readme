

# 
```
# Start dropbox if it's not running
app=$(which dropbox.py)
dropbox_status=$($app status)

if [ "$dropbox_status" == "Dropbox isn't running!" ];then
	$app start
	$app status
else
	echo "Dropbox running"
fi
```
