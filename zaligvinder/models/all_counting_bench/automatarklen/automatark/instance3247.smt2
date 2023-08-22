(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; <img[^>]*src=\"?([^\"]*)\"?([^>]*alt=\"?([^\"]*)\"?)?[^>]*>
(assert (not (str.in_re X (re.++ (str.to_re "<img") (re.* (re.comp (str.to_re ">"))) (str.to_re "src=") (re.opt (str.to_re "\u{22}")) (re.* (re.comp (str.to_re "\u{22}"))) (re.opt (str.to_re "\u{22}")) (re.opt (re.++ (re.* (re.comp (str.to_re ">"))) (str.to_re "alt=") (re.opt (str.to_re "\u{22}")) (re.* (re.comp (str.to_re "\u{22}"))) (re.opt (str.to_re "\u{22}")))) (re.* (re.comp (str.to_re ">"))) (str.to_re ">\u{0a}")))))
; /\/click\?sid=\w{40}\&cid=/Ui
(assert (not (str.in_re X (re.++ (str.to_re "//click?sid=") ((_ re.loop 40 40) (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "&cid=/Ui\u{0a}")))))
; ^[0]*?[1-9]\d*\.?[0]*$
(assert (not (str.in_re X (re.++ (re.* (str.to_re "0")) (re.range "1" "9") (re.* (re.range "0" "9")) (re.opt (str.to_re ".")) (re.* (str.to_re "0")) (str.to_re "\u{0a}")))))
; hirmvtg\u{2f}ggqh\.kqh\w+whenu\x2Ecom\w+weatherHost\x3AUser-Agent\x3A
(assert (str.in_re X (re.++ (str.to_re "hirmvtg/ggqh.kqh\u{1b}") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "whenu.com\u{13}") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "weatherHost:User-Agent:\u{0a}"))))
; <[^>]*?>
(assert (not (str.in_re X (re.++ (str.to_re "<") (re.* (re.comp (str.to_re ">"))) (str.to_re ">\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
