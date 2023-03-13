(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^([0-9]{8})|(R[0-9]{7})|((AC|FC|GE|GN|GS|IC|IP|LP|NA|NF|NI|NL|NO|NP|NR|NZ|OC|RC|SA|SC|SF|SI|SL|SO|SP|SR)[0-9]{6})$
(assert (not (str.in_re X (re.union ((_ re.loop 8 8) (re.range "0" "9")) (re.++ (str.to_re "R") ((_ re.loop 7 7) (re.range "0" "9"))) (re.++ (str.to_re "\u{0a}") (re.union (str.to_re "AC") (str.to_re "FC") (str.to_re "GE") (str.to_re "GN") (str.to_re "GS") (str.to_re "IC") (str.to_re "IP") (str.to_re "LP") (str.to_re "NA") (str.to_re "NF") (str.to_re "NI") (str.to_re "NL") (str.to_re "NO") (str.to_re "NP") (str.to_re "NR") (str.to_re "NZ") (str.to_re "OC") (str.to_re "RC") (str.to_re "SA") (str.to_re "SC") (str.to_re "SF") (str.to_re "SI") (str.to_re "SL") (str.to_re "SO") (str.to_re "SP") (str.to_re "SR")) ((_ re.loop 6 6) (re.range "0" "9")))))))
; ^(\d|,)*\d*$
(assert (not (str.in_re X (re.++ (re.* (re.union (re.range "0" "9") (str.to_re ","))) (re.* (re.range "0" "9")) (str.to_re "\u{0a}")))))
; www\.take5bingo\.com\d+Host\x3AHost\x3A
(assert (str.in_re X (re.++ (str.to_re "www.take5bingo.com\u{1b}") (re.+ (re.range "0" "9")) (str.to_re "Host:Host:\u{0a}"))))
; Host\x3A.*Hello\x2E.*Referer\x3AToolbarCurrent\x3BCIA
(assert (not (str.in_re X (re.++ (str.to_re "Host:") (re.* re.allchar) (str.to_re "Hello.") (re.* re.allchar) (str.to_re "Referer:ToolbarCurrent;CIA\u{0a}")))))
(check-sat)
