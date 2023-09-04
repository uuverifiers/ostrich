(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; Host\u{3a}\w+Pre.*Keyloggeradfsgecoiwnfhirmvtg\u{2f}ggqh\.kqh
(assert (not (str.in_re X (re.++ (str.to_re "Host:") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "Pre") (re.* re.allchar) (str.to_re "Keyloggeradfsgecoiwnf\u{1b}hirmvtg/ggqh.kqh\u{1b}\u{0a}")))))
; Host\x3A\d+Subject\x3A[^\n\r]*Seconds\-ovplHost\x3AHost\x3ADownload
(assert (str.in_re X (re.++ (str.to_re "Host:") (re.+ (re.range "0" "9")) (str.to_re "Subject:") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "Seconds-ovplHost:Host:Download\u{0a}"))))
; ^(((((0?[1-9]|[12]\d|3[01])[-/]([0]?[13578]|1[02]))|((0?[1-9]|[12]\d|30)[-/]([0]?[469]|11))|(([01]?\d|2[0-8])[-/]0?2))[-/]((20|19)?\d{2}|\d{1,2}))|(29[-/]0?2[-/]((19)|(20))?([13579][26]|[24680][048])))$
(assert (not (str.in_re X (re.++ (re.union (re.++ (re.union (re.++ (re.union (re.++ (re.opt (str.to_re "0")) (re.range "1" "9")) (re.++ (re.union (str.to_re "1") (str.to_re "2")) (re.range "0" "9")) (re.++ (str.to_re "3") (re.union (str.to_re "0") (str.to_re "1")))) (re.union (str.to_re "-") (str.to_re "/")) (re.union (re.++ (re.opt (str.to_re "0")) (re.union (str.to_re "1") (str.to_re "3") (str.to_re "5") (str.to_re "7") (str.to_re "8"))) (re.++ (str.to_re "1") (re.union (str.to_re "0") (str.to_re "2"))))) (re.++ (re.union (re.++ (re.opt (str.to_re "0")) (re.range "1" "9")) (re.++ (re.union (str.to_re "1") (str.to_re "2")) (re.range "0" "9")) (str.to_re "30")) (re.union (str.to_re "-") (str.to_re "/")) (re.union (re.++ (re.opt (str.to_re "0")) (re.union (str.to_re "4") (str.to_re "6") (str.to_re "9"))) (str.to_re "11"))) (re.++ (re.union (re.++ (re.opt (re.union (str.to_re "0") (str.to_re "1"))) (re.range "0" "9")) (re.++ (str.to_re "2") (re.range "0" "8"))) (re.union (str.to_re "-") (str.to_re "/")) (re.opt (str.to_re "0")) (str.to_re "2"))) (re.union (str.to_re "-") (str.to_re "/")) (re.union (re.++ (re.opt (re.union (str.to_re "20") (str.to_re "19"))) ((_ re.loop 2 2) (re.range "0" "9"))) ((_ re.loop 1 2) (re.range "0" "9")))) (re.++ (str.to_re "29") (re.union (str.to_re "-") (str.to_re "/")) (re.opt (str.to_re "0")) (str.to_re "2") (re.union (str.to_re "-") (str.to_re "/")) (re.opt (re.union (str.to_re "19") (str.to_re "20"))) (re.union (re.++ (re.union (str.to_re "1") (str.to_re "3") (str.to_re "5") (str.to_re "7") (str.to_re "9")) (re.union (str.to_re "2") (str.to_re "6"))) (re.++ (re.union (str.to_re "2") (str.to_re "4") (str.to_re "6") (str.to_re "8") (str.to_re "0")) (re.union (str.to_re "0") (str.to_re "4") (str.to_re "8")))))) (str.to_re "\u{0a}")))))
; /filename=[^\n]*\u{2e}ppt/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".ppt/i\u{0a}")))))
; www\.trackhits\.cc\s+wwwHost\u{3a}RobertVersionspyblini\x2Eini
(assert (str.in_re X (re.++ (str.to_re "www.trackhits.cc") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "wwwHost:RobertVersionspyblini.ini\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)