(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /version\x3D[\u{22}\u{27}][^\u{22}\u{27}]{1024}/
(assert (not (str.in_re X (re.++ (str.to_re "/version=") (re.union (str.to_re "\u{22}") (str.to_re "'")) ((_ re.loop 1024 1024) (re.union (str.to_re "\u{22}") (str.to_re "'"))) (str.to_re "/\u{0a}")))))
; /^[0-9]+\.d{3}? *$/
(assert (not (str.in_re X (re.++ (str.to_re "/") (re.+ (re.range "0" "9")) (str.to_re ".") ((_ re.loop 3 3) (str.to_re "d")) (re.* (str.to_re " ")) (str.to_re "/\u{0a}")))))
; X-Mailer\u{3a}wlpgskmv\u{2f}lwzo\.qv#Subject\u{3a}Activity
(assert (not (str.in_re X (str.to_re "X-Mailer:\u{13}wlpgskmv/lwzo.qv#Subject:Activity\u{0a}"))))
; /^\u{2f}[A-Za-z0-9+~=]{16,17}\u{2f}[A-Za-z0-9+~=]{35,40}\u{2f}[A-Za-z0-9+~=]{8}\u{2f}[A-Za-z0-9+~=]*?\u{2f}[A-Za-z0-9+~=]{12,30}$/I
(assert (not (str.in_re X (re.++ (str.to_re "//") ((_ re.loop 16 17) (re.union (re.range "A" "Z") (re.range "a" "z") (re.range "0" "9") (str.to_re "+") (str.to_re "~") (str.to_re "="))) (str.to_re "/") ((_ re.loop 35 40) (re.union (re.range "A" "Z") (re.range "a" "z") (re.range "0" "9") (str.to_re "+") (str.to_re "~") (str.to_re "="))) (str.to_re "/") ((_ re.loop 8 8) (re.union (re.range "A" "Z") (re.range "a" "z") (re.range "0" "9") (str.to_re "+") (str.to_re "~") (str.to_re "="))) (str.to_re "/") (re.* (re.union (re.range "A" "Z") (re.range "a" "z") (re.range "0" "9") (str.to_re "+") (str.to_re "~") (str.to_re "="))) (str.to_re "/") ((_ re.loop 12 30) (re.union (re.range "A" "Z") (re.range "a" "z") (re.range "0" "9") (str.to_re "+") (str.to_re "~") (str.to_re "="))) (str.to_re "/I\u{0a}")))))
; User-Agent\x3AHost\x3ATeomaBarHost\x3AHoursHost\x3A
(assert (str.in_re X (str.to_re "User-Agent:Host:TeomaBarHost:HoursHost:\u{0a}")))
(check-sat)
