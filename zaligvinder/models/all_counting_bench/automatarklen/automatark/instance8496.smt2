(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; com\x2Findex\.php\?tpid=onspyblpatUser-Agent\x3ASurveillance
(assert (not (str.in_re X (str.to_re "com/index.php?tpid=onspyblpatUser-Agent:Surveillance\u{13}\u{0a}"))))
; /\u{2e}jar([\?\u{5c}\u{2f}]|$)/smiU
(assert (not (str.in_re X (re.++ (str.to_re "/.jar") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}")))))
; /\/ZES\d+O\d+\.jsp\?[a-z0-9=\u{2b}\u{2f}]{20}/iU
(assert (str.in_re X (re.++ (str.to_re "//ZES") (re.+ (re.range "0" "9")) (str.to_re "O") (re.+ (re.range "0" "9")) (str.to_re ".jsp?") ((_ re.loop 20 20) (re.union (re.range "a" "z") (re.range "0" "9") (str.to_re "=") (str.to_re "+") (str.to_re "/"))) (str.to_re "/iU\u{0a}"))))
; \?<.+?>
(assert (not (str.in_re X (re.++ (str.to_re "?<") (re.+ re.allchar) (str.to_re ">\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
