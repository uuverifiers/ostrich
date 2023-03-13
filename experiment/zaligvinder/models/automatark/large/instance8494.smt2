(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /[a-z\d\u{2f}\u{2b}\u{3d}]{100,300}/Pi
(assert (str.in_re X (re.++ (str.to_re "/") ((_ re.loop 100 300) (re.union (re.range "a" "z") (re.range "0" "9") (str.to_re "/") (str.to_re "+") (str.to_re "="))) (str.to_re "/Pi\u{0a}"))))
; versionIDENTIFYstarted\x2EUser-Agent\x3A
(assert (str.in_re X (str.to_re "versionIDENTIFYstarted.User-Agent:\u{0a}")))
; ^([^ \u{21}-\u{26}\u{28}-\x2C\x2E-\u{40}\x5B-\u{60}\x7B-\xAC\xAE-\xBF\xF7\xFE]+)$
(assert (str.in_re X (re.++ (re.+ (re.union (str.to_re " ") (re.range "!" "&") (re.range "(" ",") (re.range "." "@") (re.range "[" "`") (re.range "{" "\u{ac}") (re.range "\u{ae}" "\u{bf}") (str.to_re "\u{f7}") (str.to_re "\u{fe}"))) (str.to_re "\u{0a}"))))
; /file=[\u{7c}\u{27}]/Ui
(assert (str.in_re X (re.++ (str.to_re "/file=") (re.union (str.to_re "|") (str.to_re "'")) (str.to_re "/Ui\u{0a}"))))
; Host\x3A\.exePass-OnHost\x3A\.exe\x2Ftoolbar\x2F
(assert (str.in_re X (str.to_re "Host:.exePass-OnHost:.exe/toolbar/\u{0a}")))
(check-sat)
