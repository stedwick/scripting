read -p "Flatten $(pwd)/ (y/n)? "
if [ "$REPLY" -a "$REPLY" = "y" ]; then
	find . -type f -print0 | xargs -0 -J% mv % ./
	find . -type d -delete
fi
