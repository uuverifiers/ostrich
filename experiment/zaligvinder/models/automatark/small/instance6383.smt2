(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^[\\(]{0,1}[0-9]{3}([\\)]{0,1}|-|\s){0,1}[0-9]{3}(-|\s){0,1}[0-9]{4}$
(assert (str.in_re X (re.++ (re.opt (re.union (str.to_re "\u{5c}") (str.to_re "("))) ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (re.union (re.opt (re.union (str.to_re "\u{5c}") (str.to_re ")"))) (str.to_re "-") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (re.union (str.to_re "-") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; /new (java|org)/Ui
(assert (not (str.in_re X (re.++ (str.to_re "/new ") (re.union (str.to_re "java") (str.to_re "org")) (str.to_re "/Ui\u{0a}")))))
; ^(Sun|Mon|(T(ues|hurs))|Fri)(day|\.)?$|Wed(\.|nesday)?$|Sat(\.|urday)?$|T((ue?)|(hu?r?))\.?$
(assert (not (str.in_re X (re.union (re.++ (re.union (str.to_re "Sun") (str.to_re "Mon") (re.++ (str.to_re "T") (re.union (str.to_re "ues") (str.to_re "hurs"))) (str.to_re "Fri")) (re.opt (re.union (str.to_re "day") (str.to_re ".")))) (re.++ (str.to_re "Wed") (re.opt (re.union (str.to_re ".") (str.to_re "nesday")))) (re.++ (str.to_re "Sat") (re.opt (re.union (str.to_re ".") (str.to_re "urday")))) (re.++ (str.to_re "T") (re.union (re.++ (str.to_re "u") (re.opt (str.to_re "e"))) (re.++ (str.to_re "h") (re.opt (str.to_re "u")) (re.opt (str.to_re "r")))) (re.opt (str.to_re ".")) (str.to_re "\u{0a}"))))))
; frame_ver2\s+communityLibrarySoftwareWinCrashcomHost\x3Atid\x3D\u{25}toolbar\x5Fid
(assert (str.in_re X (re.++ (str.to_re "frame_ver2") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "communityLibrarySoftwareWinCrashcomHost:tid=%toolbar_id\u{0a}"))))
(check-sat)
