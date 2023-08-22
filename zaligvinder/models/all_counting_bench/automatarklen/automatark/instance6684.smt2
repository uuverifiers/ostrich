(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /^\/jmx.jar?r=\d+/Ui
(assert (not (str.in_re X (re.++ (str.to_re "//jmx") re.allchar (str.to_re "ja") (re.opt (str.to_re "r")) (str.to_re "r=") (re.+ (re.range "0" "9")) (str.to_re "/Ui\u{0a}")))))
; RunnerHost\u{3a}\x2Ehtmldll\x3FCenterspasSubject\x3AHost\x3AconnectedNodes\u{26}Name=
(assert (not (str.in_re X (str.to_re "RunnerHost:.htmldll?CenterspasSubject:Host:connectedNodes&Name=\u{0a}"))))
; ^[0-9]{10}GBR[0-9]{7}[U,M,F]{1}[0-9]{9}$
(assert (str.in_re X (re.++ ((_ re.loop 10 10) (re.range "0" "9")) (str.to_re "GBR") ((_ re.loop 7 7) (re.range "0" "9")) ((_ re.loop 1 1) (re.union (str.to_re "U") (str.to_re ",") (str.to_re "M") (str.to_re "F"))) ((_ re.loop 9 9) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; SpywareStrike.*Subject\x3A\s+Pcast\x2Edat\x2EToolbar
(assert (not (str.in_re X (re.++ (str.to_re "SpywareStrike") (re.* re.allchar) (str.to_re "Subject:") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Pcast.dat.Toolbar\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
