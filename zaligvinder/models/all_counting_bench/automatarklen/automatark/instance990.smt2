(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /^\/[0-9]{8}\.html$/U
(assert (not (str.in_re X (re.++ (str.to_re "//") ((_ re.loop 8 8) (re.range "0" "9")) (str.to_re ".html/U\u{0a}")))))
; http\x3A\x2F\x2Fwww\.searchinweb\.com\x2Fsearch\.php\?said=bar
(assert (not (str.in_re X (str.to_re "http://www.searchinweb.com/search.php?said=bar\u{0a}"))))
; ^(([0-1]?[1-9]|2[0-3])(:)([0-5][0-9]))$
(assert (str.in_re X (re.++ (str.to_re "\u{0a}") (re.union (re.++ (re.opt (re.range "0" "1")) (re.range "1" "9")) (re.++ (str.to_re "2") (re.range "0" "3"))) (str.to_re ":") (re.range "0" "5") (re.range "0" "9"))))
; Host\x3A\sHello\x2E.*forum=
(assert (str.in_re X (re.++ (str.to_re "Host:") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "Hello.") (re.* re.allchar) (str.to_re "forum=\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
