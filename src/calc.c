#include <stdio.h>
#include "calc.h"

float calcTotal(const Student *stu)
{
    float t = 0;
    for (int i = 0; i < COURSE_COUNT; i++)
        t += stu->score[i];
    return t;
}

float calcAverage(const Student *stu)
{
    return stu->total / COURSE_COUNT;
}

void calcAll(StudentDB *db)
{
    for (int i = 0; i < db->count; i++)
    {
        db->stu[i].total = calcTotal(&db->stu[i]);
        db->stu[i].average = calcAverage(&db->stu[i]);
    }
}

void sortByTotal(StudentDB *db)
{
    if (db == NULL || db->count <= 1)
    {
        return;
    }
    printf("正在按总分从高到低排序...\n");
    int n = db->count;
    int swapped;
    do
    {
        swapped = 0;
        for (int i = 0; i < n - 1; i++)
        {
            if (db->stu[i].total < db->stu[i + 1].total)
            {
                Student temp = db->stu[i];
                db->stu[i] = db->stu[i + 1];
                db->stu[i + 1] = temp;
                swapped = 1;
            }
        }
        n--;
    } while (swapped);
    printf("排序完成！\n");
}
void courseAnalysis(const StudentDB *db)
{
    // TODO: C、D 负责
}
