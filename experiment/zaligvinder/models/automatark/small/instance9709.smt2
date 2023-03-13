(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /filename=[^\n]*\u{2e}ppsx/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".ppsx/i\u{0a}")))))
; /(00356)?(99|79|77|21|27|22|25)[0-9]{6}/g
(assert (str.in_re X (re.++ (str.to_re "/") (re.opt (str.to_re "00356")) (re.union (str.to_re "99") (str.to_re "79") (str.to_re "77") (str.to_re "21") (str.to_re "27") (str.to_re "22") (str.to_re "25")) ((_ re.loop 6 6) (re.range "0" "9")) (str.to_re "/g\u{0a}"))))
; url=\swww\x2Ealfacleaner\x2Ecom\d+Host\x3A\x2Fproducts\x2Fspyblocs\x2F
(assert (str.in_re X (re.++ (str.to_re "url=") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "www.alfacleaner.com") (re.+ (re.range "0" "9")) (str.to_re "Host:/products/spyblocs/\u{13}\u{0a}"))))
; User-Agent\x3A\d+dll\x3F.*started\x2EfeedbackUser-Agent\x3A
(assert (str.in_re X (re.++ (str.to_re "User-Agent:") (re.+ (re.range "0" "9")) (str.to_re "dll?") (re.* re.allchar) (str.to_re "started.feedbackUser-Agent:\u{0a}"))))
(check-sat)
