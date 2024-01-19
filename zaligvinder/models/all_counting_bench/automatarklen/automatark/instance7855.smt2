(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^0[1-6]{1}(([0-9]{2}){4})|((\s[0-9]{2}){4})|((-[0-9]{2}){4})$
(assert (not (str.in_re X (re.union (re.++ (str.to_re "0") ((_ re.loop 1 1) (re.range "1" "6")) ((_ re.loop 4 4) ((_ re.loop 2 2) (re.range "0" "9")))) ((_ re.loop 4 4) (re.++ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) ((_ re.loop 2 2) (re.range "0" "9")))) (re.++ ((_ re.loop 4 4) (re.++ (str.to_re "-") ((_ re.loop 2 2) (re.range "0" "9")))) (str.to_re "\u{0a}"))))))
; ^((http://)|(https://))((([a-zA-Z0-9_-]*).?([a-zA-Z0-9_-]*))|(([a-zA-Z0-9_-]*).?([a-zA-Z0-9_-]*).?([a-zA-Z0-9_-]*)))/?([a-zA-Z0-9_/?%=&+#.-~]*)$
(assert (str.in_re X (re.++ (re.union (str.to_re "http://") (str.to_re "https://")) (re.union (re.++ (re.* (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "_") (str.to_re "-"))) (re.opt re.allchar) (re.* (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "_") (str.to_re "-")))) (re.++ (re.* (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "_") (str.to_re "-"))) (re.opt re.allchar) (re.* (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "_") (str.to_re "-"))) (re.opt re.allchar) (re.* (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "_") (str.to_re "-"))))) (re.opt (str.to_re "/")) (re.* (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "_") (str.to_re "/") (str.to_re "?") (str.to_re "%") (str.to_re "=") (str.to_re "&") (str.to_re "+") (str.to_re "#") (re.range "." "~"))) (str.to_re "\u{0a}"))))
; \swww\.fast-finder\.com[^\n\r]*\x2Fbar_pl\x2Fchk\.fcgi\d+Toolbar
(assert (str.in_re X (re.++ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "www.fast-finder.com") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "/bar_pl/chk.fcgi") (re.+ (re.range "0" "9")) (str.to_re "Toolbar\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
