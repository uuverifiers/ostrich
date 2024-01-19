(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; dll\x3F\[DRIVEHost\x3A\u{b0}\u{ae}\u{b6}\u{f9}\u{cd}\u{f8}\u{b5}\u{c1}
(assert (str.in_re X (str.to_re "dll?[DRIVEHost:\u{b0}\u{ae}\u{b6}\u{f9}\u{cd}\u{f8}\u{b5}\u{c1}\u{0a}")))
; BV_SessionID=@@@@0106700396.1206001747@@@@&BV_EngineID=ccckadedjddehggcefecehidfhfdflg.0
(assert (not (str.in_re X (re.++ (str.to_re "BV_SessionID=@@@@0106700396") re.allchar (str.to_re "1206001747@@@@&BV_EngineID=ccckadedjddehggcefecehidfhfdflg") re.allchar (str.to_re "0\u{0a}")))))
; www\x2Efreescratchandwin\x2Ecom\w+Port.*User-Agent\x3AToolbarkit
(assert (not (str.in_re X (re.++ (str.to_re "www.freescratchandwin.com") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "Port") (re.* re.allchar) (str.to_re "User-Agent:Toolbarkit\u{0a}")))))
; ^[a-zA-Z0-9_.-]+@[a-zA-Z0-9-]+.[a-zA-Z0-9-.]+$
(assert (not (str.in_re X (re.++ (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "_") (str.to_re ".") (str.to_re "-"))) (str.to_re "@") (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "-"))) re.allchar (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "-") (str.to_re "."))) (str.to_re "\u{0a}")))))
; ([A-Z]:\\[^/:\*\?<>\|]+\.\w{2,6})|(\\{2}[^/:\*\?<>\|]+\.\w{2,6})
(assert (str.in_re X (re.union (re.++ (re.range "A" "Z") (str.to_re ":\u{5c}") (re.+ (re.union (str.to_re "/") (str.to_re ":") (str.to_re "*") (str.to_re "?") (str.to_re "<") (str.to_re ">") (str.to_re "|"))) (str.to_re ".") ((_ re.loop 2 6) (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_")))) (re.++ (str.to_re "\u{0a}") ((_ re.loop 2 2) (str.to_re "\u{5c}")) (re.+ (re.union (str.to_re "/") (str.to_re ":") (str.to_re "*") (str.to_re "?") (str.to_re "<") (str.to_re ">") (str.to_re "|"))) (str.to_re ".") ((_ re.loop 2 6) (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_")))))))
(assert (> (str.len X) 10))
(check-sat)
