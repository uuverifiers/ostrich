(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^\d{4,}$|^[3-9]\d{2}$|^2[5-9]\d$
(assert (str.in_re X (re.union (re.++ ((_ re.loop 4 4) (re.range "0" "9")) (re.* (re.range "0" "9"))) (re.++ (re.range "3" "9") ((_ re.loop 2 2) (re.range "0" "9"))) (re.++ (str.to_re "2") (re.range "5" "9") (re.range "0" "9") (str.to_re "\u{0a}")))))
; sql.*badurl\x2Egrandstreetinteractive\x2Ecom
(assert (str.in_re X (re.++ (str.to_re "sql") (re.* re.allchar) (str.to_re "badurl.grandstreetinteractive.com\u{0a}"))))
; /filename=[^\n]*\u{2e}rat/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".rat/i\u{0a}")))))
; Server\s+Basic\d+action\x2EpioletHost\x3AIP-www\x2Einternetadvertisingcompany\x2Ebiz
(assert (not (str.in_re X (re.++ (str.to_re "Server") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Basic") (re.+ (re.range "0" "9")) (str.to_re "action.pioletHost:IP-www.internetadvertisingcompany.biz\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
