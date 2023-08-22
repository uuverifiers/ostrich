(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; badurl\x2Egrandstreetinteractive\x2EcomFilteredHost\x3Ae2give\.com\x2Fnewsurfer4\x2F
(assert (not (str.in_re X (str.to_re "badurl.grandstreetinteractive.comFilteredHost:e2give.com/newsurfer4/\u{0a}"))))
; is\s+lnzzlnbk\u{2f}pkrm\.fin\s+Host\x3A\x2Ftoolbar\x2Fsupremetb
(assert (not (str.in_re X (re.++ (str.to_re "is") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "lnzzlnbk/pkrm.fin") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Host:/toolbar/supremetb\u{0a}")))))
; (NOT)?(\s*\(*)\s*(\w+)\s*(=|<>|<|>|LIKE|IN)\s*(\(([^\)]*)\)|'([^']*)'|(-?\d*\.?\d+))(\s*\)*\s*)(AND|OR)?
(assert (str.in_re X (re.++ (re.opt (str.to_re "NOT")) (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.union (str.to_re "=") (str.to_re "<>") (str.to_re "<") (str.to_re ">") (str.to_re "LIKE") (str.to_re "IN")) (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.union (re.++ (str.to_re "(") (re.* (re.comp (str.to_re ")"))) (str.to_re ")")) (re.++ (str.to_re "'") (re.* (re.comp (str.to_re "'"))) (str.to_re "'")) (re.++ (re.opt (str.to_re "-")) (re.* (re.range "0" "9")) (re.opt (str.to_re ".")) (re.+ (re.range "0" "9")))) (re.opt (re.union (str.to_re "AND") (str.to_re "OR"))) (str.to_re "\u{0a}") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.* (str.to_re "(")) (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.* (str.to_re ")")) (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))))))
; ^\d{1,2}\.\d{3}\.\d{3}[-][0-9kK]{1}$
(assert (not (str.in_re X (re.++ ((_ re.loop 1 2) (re.range "0" "9")) (str.to_re ".") ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re ".") ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 1 1) (re.union (re.range "0" "9") (str.to_re "k") (str.to_re "K"))) (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
