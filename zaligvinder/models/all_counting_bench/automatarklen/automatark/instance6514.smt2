(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /\/click\?sid=\w{40}\&cid=/Ui
(assert (not (str.in_re X (re.++ (str.to_re "//click?sid=") ((_ re.loop 40 40) (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "&cid=/Ui\u{0a}")))))
; /filename=[^\n]*\u{2e}otf/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".otf/i\u{0a}"))))
; (.*\.jpe?g|.*\.JPE?G)
(assert (not (str.in_re X (re.++ (re.union (re.++ (re.* re.allchar) (str.to_re ".jp") (re.opt (str.to_re "e")) (str.to_re "g")) (re.++ (re.* re.allchar) (str.to_re ".JP") (re.opt (str.to_re "E")) (str.to_re "G"))) (str.to_re "\u{0a}")))))
; ^((\d{1,3}(,\d{3})*)|(\d{1,3}))$
(assert (str.in_re X (re.++ (re.union (re.++ ((_ re.loop 1 3) (re.range "0" "9")) (re.* (re.++ (str.to_re ",") ((_ re.loop 3 3) (re.range "0" "9"))))) ((_ re.loop 1 3) (re.range "0" "9"))) (str.to_re "\u{0a}"))))
; hjhgquqssq\u{2f}pjm[^\n\r]*User-Agent\x3A
(assert (str.in_re X (re.++ (str.to_re "hjhgquqssq/pjm") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "User-Agent:\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
