(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; [:]{1}[-~+o]?[)>]+
(assert (not (str.in_re X (re.++ ((_ re.loop 1 1) (str.to_re ":")) (re.opt (re.union (str.to_re "-") (str.to_re "~") (str.to_re "+") (str.to_re "o"))) (re.+ (re.union (str.to_re ")") (str.to_re ">"))) (str.to_re "\u{0a}")))))
; /^From\u{3a}[^\r\n]*SpyBuddy/smi
(assert (str.in_re X (re.++ (str.to_re "/From:") (re.* (re.union (str.to_re "\u{0d}") (str.to_re "\u{0a}"))) (str.to_re "SpyBuddy/smi\u{0a}"))))
; IPOblivionhoroscopefowclxccdxn\u{2f}uxwn\.ddy
(assert (str.in_re X (str.to_re "IPOblivionhoroscopefowclxccdxn/uxwn.ddy\u{0a}")))
; Subject\u{3a}reportGatorNavExcel
(assert (str.in_re X (str.to_re "Subject:reportGatorNavExcel\u{0a}")))
(check-sat)
