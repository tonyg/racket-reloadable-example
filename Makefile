run:
	SITE_RELOADABLE=yes ./run

reload:
	touch signals/.reload

# This is intended for when the service is running under daemontools
restart:
	touch signals/.restart

clean:
	find . -depth -type d -iname compiled -exec rm -rf {} \;

.PHONY: run
