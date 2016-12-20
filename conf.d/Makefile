# missing "; @:" for recipeless rules makes SHELL payload useless
# (see also ../lib/report.mk); this results in broken target graphs
# (so REPORT=1 gets crippled)
check:
	@grep -E '^[a-z]+/.*: .*[^\\:]$$' *.mk
