(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; Host\x3A.*NETObserve\d+Host\u{3a}ohgdhkzfhdzo\u{2f}uwpOK\r\n
(assert (str.in_re X (re.++ (str.to_re "Host:") (re.* re.allchar) (str.to_re "NETObserve") (re.+ (re.range "0" "9")) (str.to_re "Host:ohgdhkzfhdzo/uwpOK\u{0d}\u{0a}\u{0a}"))))
; /rapidshare\.com\/files\/(\d+)\/([^\'^\"^\s^>^<^\\^\/]+)/
(assert (str.in_re X (re.++ (str.to_re "/rapidshare.com/files/") (re.+ (re.range "0" "9")) (str.to_re "/") (re.+ (re.union (str.to_re "'") (str.to_re "^") (str.to_re "\u{22}") (str.to_re ">") (str.to_re "<") (str.to_re "\u{5c}") (str.to_re "/") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "/\u{0a}"))))
; /\/AES\d{9}O\d{4,5}\u{2e}jsp/Ui
(assert (not (str.in_re X (re.++ (str.to_re "//AES") ((_ re.loop 9 9) (re.range "0" "9")) (str.to_re "O") ((_ re.loop 4 5) (re.range "0" "9")) (str.to_re ".jsp/Ui\u{0a}")))))
; Host\u{3a}\w+Host\x3A.*Host\u{3a}ToolbarServerserver\x7D\x7BSysuptime\x3A
(assert (not (str.in_re X (re.++ (str.to_re "Host:") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "Host:") (re.* re.allchar) (str.to_re "Host:ToolbarServerserver}{Sysuptime:\u{0a}")))))
; /filename=[^\n]*\u{2e}swf/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".swf/i\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
