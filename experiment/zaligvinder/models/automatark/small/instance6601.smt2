(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; Keylogger[^\n\r]*dll\x3F\w+www2\u{2e}instantbuzz\u{2e}com\s+Online100013Agentsvr\x5E\x5EMerlinHost\x3AHost\x3Aport
(assert (str.in_re X (re.++ (str.to_re "Keylogger") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "dll?") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "www2.instantbuzz.com") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Online100013Agentsvr^^Merlin\u{13}Host:Host:port\u{0a}"))))
; /filename=[^\n]*\u{2e}vap/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".vap/i\u{0a}"))))
; www\x2Eslinkyslate.*Redirector\u{22}.*Host\x3Atoolbarplace\x2Ecom
(assert (str.in_re X (re.++ (str.to_re "www.slinkyslate") (re.* re.allchar) (str.to_re "Redirector\u{22}") (re.* re.allchar) (str.to_re "Host:toolbarplace.com\u{0a}"))))
; ^[-]?\d{1,10}\.?([0-9][0-9])?$
(assert (str.in_re X (re.++ (re.opt (str.to_re "-")) ((_ re.loop 1 10) (re.range "0" "9")) (re.opt (str.to_re ".")) (re.opt (re.++ (re.range "0" "9") (re.range "0" "9"))) (str.to_re "\u{0a}"))))
; /filename=[^\n]*\u{2e}f4a/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".f4a/i\u{0a}")))))
(check-sat)
