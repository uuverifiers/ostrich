(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /filename=[^\n]*\u{2e}amf/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".amf/i\u{0a}"))))
; on\w+Host\x3AComputerKeylogger\x2EcomHost\x3AUser-Agent\x3A
(assert (not (str.in_re X (re.++ (str.to_re "on") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "Host:ComputerKeylogger.comHost:User-Agent:\u{0a}")))))
; /filename=[^\n]*\u{2e}otf/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".otf/i\u{0a}"))))
; ^([987]{1})(\d{1})(\d{8})
(assert (not (str.in_re X (re.++ ((_ re.loop 1 1) (re.union (str.to_re "9") (str.to_re "8") (str.to_re "7"))) ((_ re.loop 1 1) (re.range "0" "9")) ((_ re.loop 8 8) (re.range "0" "9")) (str.to_re "\u{0a}")))))
(check-sat)
