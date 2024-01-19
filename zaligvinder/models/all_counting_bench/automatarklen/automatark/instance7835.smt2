(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; (FR-?)?[0-9A-Z]{2}\ ?[0-9]{9}
(assert (str.in_re X (re.++ (re.opt (re.++ (str.to_re "FR") (re.opt (str.to_re "-")))) ((_ re.loop 2 2) (re.union (re.range "0" "9") (re.range "A" "Z"))) (re.opt (str.to_re " ")) ((_ re.loop 9 9) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; \u{22}reaction\x2Etxt\u{22}\d+sErverdist\x2Eatlas\x2Dia\x2EcomUser-Agent\x3A
(assert (not (str.in_re X (re.++ (str.to_re "\u{22}reaction.txt\u{22}") (re.+ (re.range "0" "9")) (str.to_re "sErverdist.atlas-ia.comUser-Agent:\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
