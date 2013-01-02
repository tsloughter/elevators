PROJECT = elevators
REBAR = rebar
REBARUP = rebar -C rebar.config.upgrade

all: upgrade

app:
	@$(REBAR) compile

clean:
	@$(REBAR) clean

rel: clean-release app
	@./relx -o rel1/elevators -c rel1/relx.config

clean-release:
	rm -rf rel1/elevators rel2/elevators

upgrade: clean rel
	mkdir -p rel2/elevators/lib
	cp -R rel1/elevators/lib/elevators-1.0 rel2/elevators/lib
	mv src/elevators.app.src src/elevators.app.src.v1
	mv src/scheduler.erl src/scheduler.erl.v1
	cp upgrade/elevators.app.src src/
	cp upgrade/scheduler.erl src/
	@$(REBAR) compile
	cp upgrade/elevators.appup ./ebin/
	@./relx -o rel2/elevators -c rel2/relx.config -l rel1 release relup
	mv src/elevators.app.src.v1 src/elevators.app.src
	mv src/scheduler.erl.v1 src/scheduler.erl
