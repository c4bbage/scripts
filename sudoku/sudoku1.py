#!/usr/bin/env python3

def xyfind(m):
    print("starting index")
    for x in range(9):
        for y in range(9):
            if m[x][y] == 0 or type(m[x][y]) == list:
                # 找到X轴上缺失的数字
                _x_nums = [i for i in range(1, 10) if i not in m[x]]
                if len(_x_nums) == 1:
                    m[x][y] = _x_nums[0]
                    print("find {},{} : {}".format(x, y, m[x][y]))
                    xyfind(m)
                    continue
                print("missing X {},{} : {}".format(x, y, _x_nums))
                # 找到Y轴上缺失的数字
                _y_nums = [ii for ii in range(1, 10) if ii not in [
                    m[i][y] for i in range(9) if m[i][y] != 0 or type(m[i][y]) != list]]
                print("missing Y {},{} : {}".format(x, y, _y_nums))

                # X Y 缺失数字求一个交集
                _xy_nums = [i for i in _x_nums if i in _y_nums]
                print("missing Y and X {},{} : {}".format(x, y, _xy_nums))

                if len(list(set(_x_nums))) == 1:
                    m[x][y] = _x_nums[0]
                    print("find {},{} : {}".format(x, y, m[x][y]))
                if type(m[x][y]) == list:
                    for i in m[x][y]:
                        if i not in _xy_nums:
                            m[x][y].remove(i)
                # 整个矩阵转化为九个方阵单元
                # 0 1 2 ｜ 3 4 5 ｜ 6 7 8
                # 0 2 > x:0 y:0 - x:3 y:3
                _x = x//3
                _y = y//3
                matrix_nums = []
                for i in range(3):
                    for j in range(3):
                        if m[_x*3+i][_y*3+j] != 0:
                            matrix_nums.append(m[_x*3+i][_y*3+j])
                # 九宫格内缺失的数字
                matrix_nums = [_n for _n in range(
                    1, 10) if _n not in matrix_nums]
                # XY轴上缺失数字和九宫格内数字交集
                m[x][y] = list(set([i for i in _xy_nums if i in matrix_nums]))
                if len(list(set(m[x][y]))) == 1:
                    m[x][y] = m[x][y][0]
                    print("find {},{} : {}".format(x, y, m[x][y]))
                    xyfind(m)

if __name__ == '__main__':
    m = [
        [8, 7, 0, 0, 4, 9, 0, 6, 1],
        [0, 0, 3, 0, 7, 2, 0, 9, 0],
        [6, 0, 4, 0, 0, 0, 0, 2, 5],
        [0, 0, 0, 0, 0, 8, 0, 0, 6],
        [1, 0, 0, 7, 0, 3, 0, 4, 2],
        [0, 2, 0, 0, 0, 5, 0, 0, 0],
        [4, 6, 0, 1, 5, 7, 2, 8, 3],
        [2, 8, 1, 3, 9, 6, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0, 0]
    ]

    xyfind(m)
    for line in m:
        print(line)
