(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; Host\x3Aact=Host\u{3a}User-Agent\x3AUser-Agent\x3ALiteselect\x2FGet
(assert (str.in_re X (str.to_re "Host:act=Host:User-Agent:User-Agent:Liteselect/Get\u{0a}")))
; /\/vic\.aspx\?ver=\d\.\d\.\d+\.\d\u{26}rnd=\d{5}/Ui
(assert (not (str.in_re X (re.++ (str.to_re "//vic.aspx?ver=") (re.range "0" "9") (str.to_re ".") (re.range "0" "9") (str.to_re ".") (re.+ (re.range "0" "9")) (str.to_re ".") (re.range "0" "9") (str.to_re "&rnd=") ((_ re.loop 5 5) (re.range "0" "9")) (str.to_re "/Ui\u{0a}")))))
; /^\u{2f}[A-Z\d]{83}\u{3d}[A-Z\d]{10}$/Ui
(assert (not (str.in_re X (re.++ (str.to_re "//") ((_ re.loop 83 83) (re.union (re.range "A" "Z") (re.range "0" "9"))) (str.to_re "=") ((_ re.loop 10 10) (re.union (re.range "A" "Z") (re.range "0" "9"))) (str.to_re "/Ui\u{0a}")))))
; /filename=[^\n]*\u{2e}swf/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".swf/i\u{0a}")))))
; xpsp2-\s+spyblpatHost\x3Ais\x2EphpBarFrom\x3A
(assert (not (str.in_re X (re.++ (str.to_re "xpsp2-") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "spyblpatHost:is.phpBarFrom:\u{0a}")))))
(check-sat)
