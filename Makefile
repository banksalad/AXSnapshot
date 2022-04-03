.PHONY: format lint ready
format:
	binary/swiftformat .

lint:
	binary/swiftlint

ready:
	make format && make lint
