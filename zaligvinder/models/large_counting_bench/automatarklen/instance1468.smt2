(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /\/download\.asp\?p\=\d$/Ui
(assert (not (str.in_re X (re.++ (str.to_re "//download.asp?p=") (re.range "0" "9") (str.to_re "/Ui\u{0a}")))))
; /^\u{2f}[a-z\d]{1,8}\.exe$/Ui
(assert (str.in_re X (re.++ (str.to_re "//") ((_ re.loop 1 8) (re.union (re.range "a" "z") (re.range "0" "9"))) (str.to_re ".exe/Ui\u{0a}"))))
; (^(6334)[5-9](\d{11}$|\d{13,14}$))
(assert (not (str.in_re X (re.++ (str.to_re "\u{0a}6334") (re.range "5" "9") (re.union ((_ re.loop 11 11) (re.range "0" "9")) ((_ re.loop 13 14) (re.range "0" "9")))))))
; www\.searchinweb\.com\s+User-Agent\x3Abindmqnqgijmng\u{2f}oj
(assert (str.in_re X (re.++ (str.to_re "www.searchinweb.com") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "User-Agent:bindmqnqgijmng/oj\u{0a}"))))
; /click.php\?c=\w{160}/Ui
(assert (str.in_re X (re.++ (str.to_re "/click") re.allchar (str.to_re "php?c=") ((_ re.loop 160 160) (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "/Ui\u{0a}"))))
(assert (< 200 (str.len X)))
(check-sat)
