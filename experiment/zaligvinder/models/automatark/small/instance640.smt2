(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; Iterenetbadurl\x2Egrandstreetinteractive\x2Ecom
(assert (not (str.in_re X (str.to_re "Iterenetbadurl.grandstreetinteractive.com\u{0a}"))))
; Host\u{3a}notificationwww\.thecommunicator\.net
(assert (str.in_re X (str.to_re "Host:notification\u{13}www.thecommunicator.net\u{0a}")))
; ^[0-9]*\/{1}[1-9]{1}[0-9]*$
(assert (not (str.in_re X (re.++ (re.* (re.range "0" "9")) ((_ re.loop 1 1) (str.to_re "/")) ((_ re.loop 1 1) (re.range "1" "9")) (re.* (re.range "0" "9")) (str.to_re "\u{0a}")))))
(check-sat)
