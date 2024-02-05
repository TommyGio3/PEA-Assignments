function F = HyperExp_pdf(x, l1, l2, p1)
	
	F = (x > 0) .* (p1 * l1 * exp(-l1*x) + (1-p1) * l2 * exp(-l2*x));
end