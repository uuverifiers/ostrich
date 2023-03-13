(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^[\(]? ([^0-1]){1}([0-9]){2}([-,\),/,\.])*([ ])?([^0-1]){1}([0-9]){2}[ ]?[-]?[/]?[\.]? ([0-9]){4}$
(assert (str.in_re X (re.++ (re.opt (str.to_re "(")) (str.to_re " ") ((_ re.loop 1 1) (re.range "0" "1")) ((_ re.loop 2 2) (re.range "0" "9")) (re.* (re.union (str.to_re "-") (str.to_re ",") (str.to_re ")") (str.to_re "/") (str.to_re "."))) (re.opt (str.to_re " ")) ((_ re.loop 1 1) (re.range "0" "1")) ((_ re.loop 2 2) (re.range "0" "9")) (re.opt (str.to_re " ")) (re.opt (str.to_re "-")) (re.opt (str.to_re "/")) (re.opt (str.to_re ".")) (str.to_re " ") ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; Host\x3A\d+Subject\x3A[^\n\r]*Seconds\-ovplHost\x3AHost\x3ADownload
(assert (str.in_re X (re.++ (str.to_re "Host:") (re.+ (re.range "0" "9")) (str.to_re "Subject:") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "Seconds-ovplHost:Host:Download\u{0a}"))))
; /^\u{2f}wp-content\u{2f}themes\u{2f}[A-Za-z0-9]\.php\?[A-Za-z0-9\x2B\x2F\x3D]{300}/Ui
(assert (str.in_re X (re.++ (str.to_re "//wp-content/themes/") (re.union (re.range "A" "Z") (re.range "a" "z") (re.range "0" "9")) (str.to_re ".php?") ((_ re.loop 300 300) (re.union (re.range "A" "Z") (re.range "a" "z") (re.range "0" "9") (str.to_re "+") (str.to_re "/") (str.to_re "="))) (str.to_re "/Ui\u{0a}"))))
(check-sat)
