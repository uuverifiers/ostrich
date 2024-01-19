(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /\u{2e}jmh([\?\u{5c}\u{2f}]|$)/smiU
(assert (str.in_re X (re.++ (str.to_re "/.jmh") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}"))))
; ^[0-9]{8}$
(assert (str.in_re X (re.++ ((_ re.loop 8 8) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; /User-Agent\u{3a}[^\u{0d}\u{0a}]*Java\/1\./H
(assert (not (str.in_re X (re.++ (str.to_re "/User-Agent:") (re.* (re.union (str.to_re "\u{0d}") (str.to_re "\u{0a}"))) (str.to_re "Java/1./H\u{0a}")))))
; Host\x3A\w+www.*ToolbartheServer\x3Awww\x2Esearchreslt\x2Ecom
(assert (not (str.in_re X (re.++ (str.to_re "Host:") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "www") (re.* re.allchar) (str.to_re "ToolbartheServer:www.searchreslt.com\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
