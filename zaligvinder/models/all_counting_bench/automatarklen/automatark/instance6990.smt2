(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; Ready[^\n\r]*User-Agent\x3A\s+Client\dFrom\x3AWebtool\x2Eworld2\x2EcnUser-Agent\x3AUser-Agent\u{3a}
(assert (not (str.in_re X (re.++ (str.to_re "Ready") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "User-Agent:") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Client") (re.range "0" "9") (str.to_re "From:Webtool.world2.cn\u{13}User-Agent:User-Agent:\u{0a}")))))
; /filename=[^\n]*\u{2e}swf/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".swf/i\u{0a}"))))
; \b[1-9]\b
(assert (not (str.in_re X (re.++ (re.range "1" "9") (str.to_re "\u{0a}")))))
; \+44\s\(0\)\s\d{2}\s\d{4}\s\d{4}
(assert (str.in_re X (re.++ (str.to_re "+44") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "(0)") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) ((_ re.loop 2 2) (re.range "0" "9")) (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) ((_ re.loop 4 4) (re.range "0" "9")) (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; ^([1-9]{0,1})([0-9]{1})((\.[0-9]{0,1})([0-9]{1})|(\,[0-9]{0,1})([0-9]{1}))?$
(assert (not (str.in_re X (re.++ (re.opt (re.range "1" "9")) ((_ re.loop 1 1) (re.range "0" "9")) (re.opt (re.union (re.++ ((_ re.loop 1 1) (re.range "0" "9")) (str.to_re ".") (re.opt (re.range "0" "9"))) (re.++ ((_ re.loop 1 1) (re.range "0" "9")) (str.to_re ",") (re.opt (re.range "0" "9"))))) (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
