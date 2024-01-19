(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; YAHOODesktopHost\u{3a}LOGHost\x3AtvshowticketsResultsFROM\x3A
(assert (str.in_re X (str.to_re "YAHOODesktopHost:LOGHost:tvshowticketsResultsFROM:\u{0a}")))
; /^\/\d{2,4}\.xap$/U
(assert (not (str.in_re X (re.++ (str.to_re "//") ((_ re.loop 2 4) (re.range "0" "9")) (str.to_re ".xap/U\u{0a}")))))
; /filename=[^\n]*\u{2e}doc/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".doc/i\u{0a}"))))
; /\/setup_b\.asp\?prj=\d\u{26}pid=[^\r\n]*\u{26}mac=/Ui
(assert (not (str.in_re X (re.++ (str.to_re "//setup_b.asp?prj=") (re.range "0" "9") (str.to_re "&pid=") (re.* (re.union (str.to_re "\u{0d}") (str.to_re "\u{0a}"))) (str.to_re "&mac=/Ui\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
