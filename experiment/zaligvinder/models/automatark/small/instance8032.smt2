(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^[a-zA-Z]\w{3,14}$
(assert (str.in_re X (re.++ (re.union (re.range "a" "z") (re.range "A" "Z")) ((_ re.loop 3 14) (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "\u{0a}"))))
; daosearch\x2EcomSubject\x3A
(assert (str.in_re X (str.to_re "daosearch.comSubject:\u{0a}")))
; Remote\x3Cchat\x3EX-Mailer\u{3a}www\u{2e}proventactics\u{2e}com
(assert (not (str.in_re X (str.to_re "Remote<chat>\u{1b}X-Mailer:\u{13}www.proventactics.com\u{0a}"))))
(check-sat)
