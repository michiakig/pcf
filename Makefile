test:
	ml-build interp.cm InterpTests.main
	sml @SMLload=interp.x86-darwin
