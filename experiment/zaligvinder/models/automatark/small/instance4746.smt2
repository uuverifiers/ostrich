(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; www\.trackhits\.cc\s+wwwHost\u{3a}RobertVersionspyblini\x2Eini
(assert (str.in_re X (re.++ (str.to_re "www.trackhits.cc") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "wwwHost:RobertVersionspyblini.ini\u{0a}"))))
; ^(\S+\.{1})(\S+\.{1})*([^\s\.]+\s*)$
(assert (str.in_re X (re.++ (re.* (re.++ (re.+ (re.comp (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")))) ((_ re.loop 1 1) (str.to_re ".")))) (str.to_re "\u{0a}") (re.+ (re.comp (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")))) ((_ re.loop 1 1) (str.to_re ".")) (re.+ (re.union (str.to_re ".") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))))))
; User-Agent\x3ASurveillancecomOnline
(assert (not (str.in_re X (str.to_re "User-Agent:Surveillance\u{13}comOnline\u{0a}"))))
; /\u{2e}air([\?\u{5c}\u{2f}]|$)/smiU
(assert (not (str.in_re X (re.++ (str.to_re "/.air") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}")))))
(check-sat)
