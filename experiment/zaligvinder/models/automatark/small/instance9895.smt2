(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^([a-zA-Z0-9]{1,15})$
(assert (not (str.in_re X (re.++ ((_ re.loop 1 15) (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9"))) (str.to_re "\u{0a}")))))
; Points\d+Host\u{3a}\dBasicwww\x2Ewebcruiser\x2Ecc
(assert (not (str.in_re X (re.++ (str.to_re "Points") (re.+ (re.range "0" "9")) (str.to_re "Host:") (re.range "0" "9") (str.to_re "Basicwww.webcruiser.cc\u{0a}")))))
; ^([0-9]{8})|(R[0-9]{7})|((AC|FC|GE|GN|GS|IC|IP|LP|NA|NF|NI|NL|NO|NP|NR|NZ|OC|RC|SA|SC|SF|SI|SL|SO|SP|SR)[0-9]{6})$
(assert (str.in_re X (re.union ((_ re.loop 8 8) (re.range "0" "9")) (re.++ (str.to_re "R") ((_ re.loop 7 7) (re.range "0" "9"))) (re.++ (str.to_re "\u{0a}") (re.union (str.to_re "AC") (str.to_re "FC") (str.to_re "GE") (str.to_re "GN") (str.to_re "GS") (str.to_re "IC") (str.to_re "IP") (str.to_re "LP") (str.to_re "NA") (str.to_re "NF") (str.to_re "NI") (str.to_re "NL") (str.to_re "NO") (str.to_re "NP") (str.to_re "NR") (str.to_re "NZ") (str.to_re "OC") (str.to_re "RC") (str.to_re "SA") (str.to_re "SC") (str.to_re "SF") (str.to_re "SI") (str.to_re "SL") (str.to_re "SO") (str.to_re "SP") (str.to_re "SR")) ((_ re.loop 6 6) (re.range "0" "9"))))))
; /^([a-z0-9])(([\-.]|[_]+)?([a-z0-9]+))*(@)([a-z0-9])((([-]+)?([a-z0-9]+))?)*((.[a-z]{2,3})?(.[a-z]{2,6}))$/i
(assert (str.in_re X (re.++ (str.to_re "/") (re.union (re.range "a" "z") (re.range "0" "9")) (re.* (re.++ (re.opt (re.union (re.+ (str.to_re "_")) (str.to_re "-") (str.to_re "."))) (re.+ (re.union (re.range "a" "z") (re.range "0" "9"))))) (str.to_re "@") (re.union (re.range "a" "z") (re.range "0" "9")) (re.* (re.opt (re.++ (re.opt (re.+ (str.to_re "-"))) (re.+ (re.union (re.range "a" "z") (re.range "0" "9")))))) (str.to_re "/i\u{0a}") (re.opt (re.++ re.allchar ((_ re.loop 2 3) (re.range "a" "z")))) re.allchar ((_ re.loop 2 6) (re.range "a" "z")))))
(check-sat)
