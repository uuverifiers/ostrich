(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; from\x3A\dwww\.thecommunicator\.net
(assert (not (str.in_re X (re.++ (str.to_re "from:") (re.range "0" "9") (str.to_re "www.thecommunicator.net\u{0a}")))))
; ^(\d{4})-((0[1-9])|(1[0-2]))-(0[1-9]|[12][0-9]|3[01])$
(assert (not (str.in_re X (re.++ ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "-") (re.union (re.++ (str.to_re "0") (re.range "1" "9")) (re.++ (str.to_re "1") (re.range "0" "2"))) (str.to_re "-") (re.union (re.++ (str.to_re "0") (re.range "1" "9")) (re.++ (re.union (str.to_re "1") (str.to_re "2")) (re.range "0" "9")) (re.++ (str.to_re "3") (re.union (str.to_re "0") (str.to_re "1")))) (str.to_re "\u{0a}")))))
; weather2ResultX-Sender\x3A
(assert (str.in_re X (str.to_re "weather2ResultX-Sender:\u{13}\u{0a}")))
; (0[0-9]{7}|(AC|BR|FC|GE|GN|GS|IC|IP|LP|NA|NF|NI|NL|NO|NP|NR|NZ|OC|RC|SA|SC|SF|SI|SL|SO|SP|SR|SZ|ZC|R)[0-9]{6})
(assert (str.in_re X (re.++ (re.union (re.++ (str.to_re "0") ((_ re.loop 7 7) (re.range "0" "9"))) (re.++ (re.union (str.to_re "AC") (str.to_re "BR") (str.to_re "FC") (str.to_re "GE") (str.to_re "GN") (str.to_re "GS") (str.to_re "IC") (str.to_re "IP") (str.to_re "LP") (str.to_re "NA") (str.to_re "NF") (str.to_re "NI") (str.to_re "NL") (str.to_re "NO") (str.to_re "NP") (str.to_re "NR") (str.to_re "NZ") (str.to_re "OC") (str.to_re "RC") (str.to_re "SA") (str.to_re "SC") (str.to_re "SF") (str.to_re "SI") (str.to_re "SL") (str.to_re "SO") (str.to_re "SP") (str.to_re "SR") (str.to_re "SZ") (str.to_re "ZC") (str.to_re "R")) ((_ re.loop 6 6) (re.range "0" "9")))) (str.to_re "\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
