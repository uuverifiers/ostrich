(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; \x7D\x7BTrojan\x3Abacktrust\x2EcomHost\x3Apjpoptwql\u{2f}rlnj
(assert (not (str.in_re X (str.to_re "}{Trojan:backtrust.comHost:pjpoptwql/rlnj\u{0a}"))))
; ^\d{9}[\d|X]$
(assert (str.in_re X (re.++ ((_ re.loop 9 9) (re.range "0" "9")) (re.union (re.range "0" "9") (str.to_re "|") (str.to_re "X")) (str.to_re "\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
